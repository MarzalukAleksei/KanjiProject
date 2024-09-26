//
//  StoreOperations.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/09/12.
//

import Foundation

/// Предназначен для работы с данными, чтобы избежать прямого обращения к Store и обеспечить переиспользование кода
class StoreOperations {
    private let store: Store
    private let currentJLPTLevel: NouryokuLevel
    
    init(store: Store, chosenLevel: NouryokuLevel) {
        self.store = store
        self.currentJLPTLevel = chosenLevel
    }
    
    /// Обновление файла
    func updKanjiKankenFile() {
        Task {
            await store.kanjiKankenStore.saveInFileManager()
        }
    }
    
    func updKanji(_ kanji: KanjiKankenModel) {
        store.kanjiKankenStore.update(set: kanji)
    }
    
    // MARK: Устанавливает ответ в текущее слово и сохраняет его в базе
    /// Установить ответ для слова и сохранить в базе
    ///  - Parameter kanji:
    ///  - Parameter answer:
    ///  - rightAnswers: Если  больше чем константное значение, то сохранить базе с пометкой true
    func setAnswer(for kanji: KanjiKankenModel?, answer: Bool) throws {
        guard var kanji = kanji else { throw RandomWordError.nilWord }
        kanji.setCurrentDate()
        
        if answer {
            kanji.setRightAnswer()
            if kanji.rightAnwers ?? 0 > DatabaseOptions.answersInRowThird {
                kanji.setAnswer(with: true)
            }
        } else {
            kanji.setWrongAnswer()
        }
        store.kanjiKankenStore.update(set: kanji)
    }
    
    // MARK: Извлекает рандомное слово для конкретного кандзи из примеров
    func loadWord(for currentKanji: KanjiKankenModel?) -> WordModel? {
        guard let currentKanji = currentKanji else { return nil }
        var componentsArray: [[TextAndReading]] = []
        
        for level in SchoolLevel.allCases where availableWordLevels().contains(level) {
            if let arr = currentKanji.getExamplesWithReading()[level] {
                componentsArray += arr
            }
        }
        var words: Set<WordModel> = []
        for components in componentsArray {
            if let word = store.findWordInBase(with: components) {
                words.insert(word)
            }
        }
        return words.randomElement()
    }
    
    // MARK: Возвращает массив кандзи, для текущего уровня, если их в уровне ниже меньше константы, взять из следующего
    /// Метод возвращает массив для текущего и ниже уровня, в случае если элементов меньше константного значения, берет из уровня выше
    /// - НЕ ПОЗВОЛЯЕТ ПОЛУЧИТЬ КАНДЗИ ДЛЯ УРОВНЕЙ ВЫШЕ, ЕСЛИ НИЖНИЕ ЕЩЕ НЕ ПРОЙДЕНЫ
    /// - Чтобобы обойти это ограничение, свойство in lerningList должно быть false, или временная отметка и количество правильных  подряд ответов больше константного значения
    func getKanjiArray() async -> [KanjiKankenModel] {
        var result: [KanjiKankenModel] = []
        var allKanjiBelowN1 = store.kanjiKankenStore.getAllKanji(below: .N1)
        let allKanjiForCurrentLevel: [KanjiKankenModel] = kanjiForCurrentLevel(currentJLPTLevel, allKanjiBelowN1)
        let allKanjiBelowCurrentLevel: [KanjiKankenModel] = allKanji(below: currentJLPTLevel, allKanjiBelowN1)
        remove(elements: allKanjiForCurrentLevel + allKanjiBelowCurrentLevel, from: &allKanjiBelowN1)
        
        let kanjiForCurrentLevel = allKanjiForCurrentLevel.filter(filterAllKanjiForCurrentLevel).sorted { $0.id < $1.id }
        let kanjiForBelowLevel = allKanjiBelowCurrentLevel.filter(filterAllKanjiForCurrentLevel).sorted { $0.id < $1.id }
        
        result = kanjiForBelowLevel + kanjiForCurrentLevel
        var updatingKanji: [KanjiKankenModel] = []
        
        if result.count < DatabaseOptions.maxLearningElementsCount, !allKanjiBelowN1.isEmpty {
            guard var nextLevel = level(after: currentJLPTLevel) else {
                await updateKanji(array: updatingKanji)
                return result
            } // Если нил, вернуть результат и загрузить в базу изменения
            var allKanjiAfterCurrentLevel: [KanjiKankenModel] = allKanjiBelowN1.filter { $0.nouryokuLevel == nextLevel }
            remove(elements: allKanjiAfterCurrentLevel, from: &allKanjiBelowN1)
            
            while result.count < DatabaseOptions.maxLearningElementsCount, !allKanjiBelowN1.isEmpty {
                if !allKanjiAfterCurrentLevel.isEmpty {
                    var kanji = allKanjiAfterCurrentLevel.removeFirst()
                    if kanji.isInLearningList() == true, filterForAllSuitable(kanji: kanji) { // Если кандзи соответствует заданному критерию
                        result.append(kanji)
                    } else if kanji.isInLearningList() == nil {
                        kanji.addInLearningList()
                        result.append(kanji)
                        updatingKanji.append(kanji)
                    }
                } else {
                    guard let next = level(after: nextLevel) else {
                        await updateKanji(array: updatingKanji)
                        return result
                    } // Если нил, вернуть результат и загрузить в базу изменения
                    nextLevel = next
                    allKanjiAfterCurrentLevel = allKanjiBelowN1.filter { $0.nouryokuLevel == nextLevel }
                    remove(elements: allKanjiAfterCurrentLevel, from: &allKanjiBelowN1)
                }
            }
        }
        
        await updateKanji(array: updatingKanji)
        
        return result
    }
    
    // MARK: Возвращает массив кандзи, с заданными параметрами
    func getAllSuitableKanjiArray() async -> [KanjiKankenModel] {
        var result: [KanjiKankenModel] = []
        let kanjiWithSuitableLevel = store.kanjiKankenStore.getAllKanji(below: currentJLPTLevel)
        let kanjiInLearningList = kanjiWithSuitableLevel.filter { $0.isInLearningList() == true }
        var notYetLearned = Set(kanjiWithSuitableLevel.filter { $0.isInLearningList() == nil })
        var updatingKanji: [KanjiKankenModel] = []
        
        result = kanjiInLearningList.filter(filterForAllSuitable)
        
        while result.count < DatabaseOptions.maxLearningElementsCount, !notYetLearned.isEmpty {
            var kanji = notYetLearned.removeFirst()
            kanji.addInLearningList()
            updatingKanji.append(kanji)
            result.append(kanji)
        }
        
        await updateKanji(array: updatingKanji)
        
        return result
    }
    
}

extension StoreOperations {
    private func filterForAllSuitable(kanji: KanjiKankenModel) -> Bool {
        let rightAnswers = kanji.rightAnwers ?? 0
        let minutePassed = Date.minutesPassed(from: kanji.getDate())
        
        if rightAnswers < DatabaseOptions.answersInRowFirst + 1,
            minutePassed >= DatabaseOptions.minutesPassedFirst || kanji.getDate() == nil {
            return true
        }
        if rightAnswers < DatabaseOptions.answersInRowSecond + 1,
            minutePassed >= DatabaseOptions.minutesPassedSecond {
            return true
        }
        
        return false
    }
    
    private func filterAllKanjiForCurrentLevel(kanji: KanjiKankenModel) -> Bool {
        if kanji.isInLearningList() == nil {
            return true
        }

        if kanji.isInLearningList() == true {
            let rightAnswers = kanji.rightAnwers ?? 0
            let minutePassed = Date.minutesPassed(from: kanji.getDate())
            
            if rightAnswers < DatabaseOptions.answersInRowFirst + 1,
                minutePassed >= DatabaseOptions.minutesPassedFirst || kanji.getDate() == nil {
                return true
            }
            if rightAnswers < DatabaseOptions.answersInRowSecond + 1,
                minutePassed >= DatabaseOptions.minutesPassedSecond {
                return true
            }
        }
        return false
    }
    
    // MARK: Удаляет переданные кандзи из массива
    private func remove(elements kanji: [KanjiKankenModel], from array: inout [KanjiKankenModel]) {
        if !array.isEmpty {
            for element in kanji {
                for (index, arrayElement) in array.enumerated() where arrayElement.id == element.id {
                    array.remove(at: index)
                    break
                }
            }
        }
    }
    
    // MARK: Возвращает все нандзи ниже текущего уровня
    private func allKanji(below level: NouryokuLevel, _ array: [KanjiKankenModel]) -> [KanjiKankenModel] {
        var result: [KanjiKankenModel] = []
        let allLevelsBelow = allLevelsBelowCurrentLevel()
        if !allLevelsBelow.isEmpty {
            for element in array where allLevelsBelow.contains(element.nouryokuLevel ?? .another) {
                result.append(element)
            }
        }
        
        return result
    }
    
    // MARK: Возвращает все нандзи для текущего уровня
    private func kanjiForCurrentLevel(_ level: NouryokuLevel, _ array: [KanjiKankenModel]) -> [KanjiKankenModel] {
        let result: [KanjiKankenModel] = array.filter { $0.nouryokuLevel == level }
        return result
    }
    
    private func level(after currentJLPTLevel: NouryokuLevel) -> NouryokuLevel? {
        switch currentJLPTLevel {
        case .N5:
            return .N4
        case .N4:
            return .N3
        case .N3:
            return .N2
        case .N2:
            return .N1
        case _:
            return nil
        }
    }
    
    private func allLevelsBelowCurrentLevel() -> [NouryokuLevel] {
        var result: [NouryokuLevel] = []
        
        switch currentJLPTLevel {
        case .another:
            result.append(.another)
            fallthrough
        case .N1:
            result.append(.N1)
            fallthrough
        case .N2:
            result.append(.N2)
            fallthrough
        case .N3:
            result.append(.N3)
            fallthrough
        case .N4:
            result.append(.N4)
            fallthrough
        case .N5:
            result.append(.N5)
        }
        
        return result.filter { $0 != currentJLPTLevel }
    }
    
    private func availableWordLevels() -> [SchoolLevel] {
        var result: [SchoolLevel] = []
        switch currentJLPTLevel {
        case .another:
            result.append(.外)
            fallthrough
        case .N1:
            result.append(.高)
            fallthrough
        case .N2:
            result.append(.中)
            fallthrough
        case .N3, .N4, .N5:
            result.append(.小)
        }
        return result
    }
    
    // MARK: Обновляет все представленные кандзи
    private func updateKanji(array kanjiArray: [KanjiKankenModel]) async {
        await withTaskGroup(of: Void.self) { group in
            for kanji in kanjiArray {
                group.addTask { [self] in
                    await store.kanjiKankenStore.update(set: kanji)
                }
            }
//            await group.waitForAll()
        }
        
    }
}
