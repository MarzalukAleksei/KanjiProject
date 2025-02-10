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
    private let userSettings: UserSettings
    
    init(store: Store, userSettings: UserSettings) {
        self.store = store
        self.userSettings = userSettings
    }
    
    /// Обновление файл канкена
    func updKanjiKankenFile() {
        Task {
            await store.kanjiKankenStore.saveInFileManager()
        }
    }
    
    /// Обновить файл словаря
    func updBaseWordFile() {
        Task {
            await store.baseWordsStore.saveInFileManager()
        }
    }
    
    // MARK: Bushu
    /// Для  правильной работы сначала ищет варианты, потом в основном теле и, если не нашло, то по всему тексту.
    func getKeys(for currentKanji: KanjiKankenModel) throws -> [BushuModel] {
        let currentKanjiKey = currentKanji.keys
        let bushu = store.bushuStore.getAll().filter { $0.variant.contains(where: { String($0) == currentKanjiKey })}
        if bushu.isEmpty {
            return try getKeysBody(for: currentKanji)
        }
        return bushu
    }
    
    /// Возвращает все кандзи из передаваемого и ниже уровня с последним неверным ответом
    func getAllWrong(below jlptLevel: NouryokuLevel) -> [KanjiKankenModel] {
        store.kanjiKankenStore.getAllKanji(below: jlptLevel).filter { $0.showlastAnswer() == false }
    }
    
    /// Возвращает все кандзи из передаваемого уровня с последним неверным ответом
    func getAllWrong(for jlptLevel: NouryokuLevel) -> [KanjiKankenModel] {
        store.kanjiKankenStore.get(nouryokuLevel: jlptLevel).filter { $0.showlastAnswer() == false }
    }
    
    /// Возвращает массив кандзи из переданного слова
    func getKanjiArray(from word: WordModel?) -> [KanjiKankenModel] {
        var result: [KanjiKankenModel] = []
        guard let word = word else { return result }
        for element in word.body {
            if let kanji = store.kanjiKankenStore.getAll().first(where: { $0.body == String(element)}) {
                result.append(kanji)
            }
        }
        return result
    }
    
    func learningWords(for currentJLPTLevel: NouryokuLevel) -> [WordModel] {
        let words = store.baseWordsStore.getAll(for: currentJLPTLevel)
        return words
    }
    
    func getWord(from words: [WordModel]) throws -> WordModel {
        guard let word = words.randomElement() else { throw MyErrors.nilWord }
        return word
    }
    
    /// Обновляет кандзи в Store
    func updKanji(_ kanji: KanjiKankenModel) {
        store.kanjiKankenStore.update(set: kanji)
    }
    
    // MARK: Устанавливает ответ в текущее слово и сохраняет его в базе
    /// Установить ответ для слова и сохранить в базе
    ///  - Parameter kanji:
    ///  - Parameter answer:
    ///  - rightAnswers: Если  больше чем константное значение, то сохранить базе с пометкой true
    func setAnswer(for kanji: KanjiKankenModel?, answer: Answer) throws {
        guard var kanji = kanji else { throw MyErrors.nilWord }
        kanji.setCurrentDate()
        
        switch answer {
        case .right:
            kanji.setRightAnswer()
            if kanji.rightAnwers ?? 0 > DatabaseOptions.answersCounts.third {
                kanji.setLastAnswer(with: true)
            }
        case .wrong:
            kanji.setWrongAnswer()
        }
        kanji.learning()
        store.kanjiKankenStore.update(set: kanji)
    }
    
    // MARK: Извлекает рандомное слово для конкретного кандзи из примеров
    func loadKanjiWordExample(for currentKanji: KanjiKankenModel?, currentJLPTLevel: NouryokuLevel) -> WordModel? {
        guard let currentKanji = currentKanji else { return nil }
        var componentsArray: [[TextAndReading]] = []
        
        for level in SchoolLevel.allCases where availableWordLevels(for: currentJLPTLevel).contains(level) {
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
    
    // MARK: Метод ля первой загрузки экрана изучения
    /// Для первой загрузки
    func firstKanjiLoading(for currentJLPTLevel: NouryokuLevel) async -> [KanjiKankenModel] {
        var result: [KanjiKankenModel] = []
        if countOfKanjiInLearningList() == 0 {
            return await theFirstLoading(for: currentJLPTLevel)
        }
        if countOfKanjiInLearningList() < userSettings.newKanjiInConfirmationDialog {
            result = getAllInLearningList()
            result = addNotLearnedKanji(for: currentJLPTLevel, result)
        }
        return result
    }
    
    /// добавляет все с эелементы с ошибкой в последнем ответе из списка
    func addWrongsInListWithoutDataStamp() -> [KanjiKankenModel] {
        return store.kanjiKankenStore.getAll().filter { $0.isInLearningList() == true }.filter { $0.showlastAnswer() == false }
    }
    
    /// Добавить слова из списка без учета даты
    /// - ВАЖНО! Только если количество правильных ответов подряд мешьше чем константное значение
    func addKanjiWromWithoutDataStamp() -> [KanjiKankenModel] {
        return store.kanjiKankenStore.getAll().filter { $0.isInLearningList() == true }.filter(filterForAllInListWithoutData)
    }
    
    /// Добавляет кандзи не находящиеся в списке
    func addNotLearnedKanji(for currentJLPTLevel: NouryokuLevel, _ nowInList: [KanjiKankenModel] = []) -> [KanjiKankenModel] {
        var result: [KanjiKankenModel] = nowInList
        var currentLevel = currentJLPTLevel
        var allKanjiForCurrentLevel = store.kanjiKankenStore.getAllKanji(below: currentLevel).filter { $0.isInLearningList() == nil }
        find(result: &result, allKanjiForCurrentLevel: &allKanjiForCurrentLevel, level: &currentLevel)
        return result
    }
    
    // MARK: Возвращает массив кандзи, для текущего уровня, если их в уровне ниже меньше константы, взять из следующего
    /// Метод возвращает массив для текущего и ниже уровня, в случае если элементов меньше константного значения, берет из уровня выше,
    func getKanjiArray(for currentJLPTLevel: NouryokuLevel) async -> [KanjiKankenModel] {
        var result: [KanjiKankenModel] = []
        var allKanjiForCurrentLevel = store.kanjiKankenStore.getAllKanji(below: currentJLPTLevel).filter { $0.isInLearningList() != false }
        let inLearningList = filterAndRemove(&allKanjiForCurrentLevel, inLearningList: true) // Добавить все, что находятся в списке на изучение
        result = inLearningList.filter(filterAllKanjiForCurrentLevel)
        
        return result
    }
    
    // MARK: Возвращает массив кандзи, с заданными параметрами без даты
    func getAllSuitableKanjiArray(for currentJLPTLevel: NouryokuLevel) async -> [KanjiKankenModel] {
        var result: [KanjiKankenModel] = []
        let kanjiWithSuitableLevel = store.kanjiKankenStore.getAllKanji(below: currentJLPTLevel)
//        let kanjiInLearningList = kanjiWithSuitableLevel.filter { $0.isInLearningList() == true }
        var notYetLearned = Set(kanjiWithSuitableLevel.filter { $0.isInLearningList() == nil })
        var updatingKanji: [KanjiKankenModel] = []
        
        while result.count < userSettings.newKanjiInConfirmationDialog, !notYetLearned.isEmpty {
            var kanji = notYetLearned.removeFirst()
            kanji.addInLearningList()
            updatingKanji.append(kanji)
            result.append(kanji)
        }
        
        return result
    }
    
}

extension StoreOperations {
    enum Answer {
        case right
        case wrong
    }
    
    private func getKeysBody(for currentKanji: KanjiKankenModel) throws -> [BushuModel] {
        let bushu =  store.bushuStore.getAll().filter { $0.body == currentKanji.keys }
        if bushu.isEmpty {
            return try getKeysFromMeaning(for: currentKanji)
        }
        return bushu
    }
    
    private func getKeysFromMeaning(for currentKanji: KanjiKankenModel) throws -> [BushuModel] {
        let currentKanjiKey = currentKanji.keys
        let bushu = store.bushuStore.getAll().filter { $0.explanation.contains(where: { String($0) == currentKanjiKey}) }
        if bushu.isEmpty {
            throw MyErrors.wrongBushu
        }
        return bushu
    }
    
    private func getAllInLearningList() -> [KanjiKankenModel] {
        let allKanjiForCurrentLevel = store.kanjiKankenStore.getAll().filter { $0.isInLearningList() == true }
        return allKanjiForCurrentLevel.filter(filterAllKanjiForCurrentLevel)
    }
    
    private func theFirstLoading(for currentJLPTLevel: NouryokuLevel) async -> [KanjiKankenModel] {
        let result = await getKanjiArray(for: currentJLPTLevel)
        return result
    }
    
    private func countOfKanjiInLearningList() -> Int {
        let withMark = store.kanjiKankenStore.getAll().filter { $0.isInLearningList() == true }
        return withMark.count
    }
    
    // MARK: Заполняет массив result
    /// Метод заполняет result до тех пор, пока количество элементов будет мешьше чем установленная константа
    /// - В реализации использован inout
    /// - Parameter result: Заполняемый массив. Количество элементов зависит от значения константы `DatabaseOptions.newKanjiInConfirmationDialog`
    /// - Parameter allKanjiForCurrentLevel: первоначальный массив
    /// - Parameter level: текущий уровень. Если в N1 не осталось элементов, прерывается.
    private func find(result: inout [KanjiKankenModel],
                      allKanjiForCurrentLevel: inout [KanjiKankenModel],
                      level: inout NouryokuLevel) {
        while result.count < userSettings.newKanjiInConfirmationDialog, !allKanjiForCurrentLevel.isEmpty {
            let kanji = allKanjiForCurrentLevel.remove(at: Int.random(in: 0..<allKanjiForCurrentLevel.count))
            result.append(kanji)
        }
        
        if result.count < userSettings.newKanjiInConfirmationDialog, allKanjiForCurrentLevel.isEmpty {
            guard let currentlevel = nextLevel(level) else { return } // Ищет следующий уровень. Если nil, то завершить поиск
            level = currentlevel
            allKanjiForCurrentLevel = store.kanjiKankenStore.get(nouryokuLevel: level).filter { $0.isInLearningList() != false }
            let inLearningList = filterAndRemove(&allKanjiForCurrentLevel, inLearningList: true)
            result += inLearningList.filter(filterAllKanjiForCurrentLevel)
            find(result: &result, allKanjiForCurrentLevel: &allKanjiForCurrentLevel, level: &level)
        }
    }
    
    private func filterAndRemove(_ kanjiArray: inout [KanjiKankenModel], inLearningList: Bool?) -> [KanjiKankenModel] {
        var result: [KanjiKankenModel] = []
        result.append(contentsOf: kanjiArray.filter { $0.isInLearningList() == inLearningList })
        
        for element in result {
            for (index ,inArray) in kanjiArray.enumerated() where element.id == inArray.id {
                kanjiArray.remove(at: index)
                break
            }
        }
        
        return result
    }
    
    private func filterForAllInListWithoutData(kanji: KanjiKankenModel) -> Bool {
        let rightAnswers = kanji.rightAnwers ?? 0
        
        if rightAnswers < DatabaseOptions.answersCounts.first + 1 {
            return true
        }
        if rightAnswers < DatabaseOptions.answersCounts.second + 1 {
            return true
        }
        if rightAnswers < DatabaseOptions.answersCounts.third + 1 {
            return true
        }
        
        return false
    }
    
    /// Метод отвечает за проверку соответсвия даты и частоты ответов в кандзи
    private func filterAllKanjiForCurrentLevel(kanji: KanjiKankenModel) -> Bool {
        if kanji.isInLearningList() == nil {
            return true
        }

        if kanji.isInLearningList() == true {
            let rightAnswers = kanji.rightAnwers ?? 0
            let daysPassed = DatabaseOptions.passedDays
            
            if rightAnswers < DatabaseOptions.answersCounts.first + 1,
               kanji.getDate().passed(days: daysPassed.first, to: Date()) >= daysPassed.first {
                return true
            }
            
            if rightAnswers < DatabaseOptions.answersCounts.second + 1,
               kanji.getDate().passed(days: daysPassed.second, to: Date()) >= daysPassed.second {
                return true
            }
            
            if rightAnswers < DatabaseOptions.answersCounts.third + 1,
               kanji.getDate().passed(days: daysPassed.third, to: Date()) >= daysPassed.third {
                return true
            }
            
            if kanji.getDate() == nil {
                print("Kanji Date Value is nil -- Called storeOperations.filterAllKanjiForCurrentLevel")
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
//    private func allKanji(below currentJLPTLevel: NouryokuLevel, _ array: [KanjiKankenModel]) -> [KanjiKankenModel] {
//        var result: [KanjiKankenModel] = []
//        let allLevelsBelow = allLevels(below: currentJLPTLevel)
//        if !allLevelsBelow.isEmpty {
//            for element in array where allLevelsBelow.contains(element.nouryokuLevel ?? .another) {
//                result.append(element)
//            }
//        }
//        
//        return result
//    }
    
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
    
    private func nextLevel(_ currentLevel: NouryokuLevel) -> NouryokuLevel? {
        switch currentLevel {
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
    
    /// Возвращает массив уровней ниже текущего
//    private func allLevels(below currentJLPTLevel: NouryokuLevel) -> [NouryokuLevel] {
//        var result: [NouryokuLevel] = []
//        
//        switch currentJLPTLevel {
//        case .another:
//            result.append(.another)
//            fallthrough
//        case .N1:
//            result.append(.N1)
//            fallthrough
//        case .N2:
//            result.append(.N2)
//            fallthrough
//        case .N3:
//            result.append(.N3)
//            fallthrough
//        case .N4:
//            result.append(.N4)
//            fallthrough
//        case .N5:
//            result.append(.N5)
//        }
//        
//        return result.filter { $0 != currentJLPTLevel }
//    }
    
    private func allLevels(below currentLevel: KankenLevel) -> [KankenLevel] {
        var result: [KankenLevel] = []
        switch currentLevel {
        case .級01:
            result.append(.級01)
            fallthrough
        case .準01:
            result.append(.準01)
            fallthrough
        case .級02:
            result.append(.級02)
            fallthrough
        case .準02:
            result.append(.準02)
            fallthrough
        case .級03:
            result.append(.級03)
            fallthrough
        case .級04:
            result.append(.級04)
            fallthrough
        case .級05:
            result.append(.級05)
            fallthrough
        case .級06:
            result.append(.級06)
            fallthrough
        case .級07:
            result.append(.級07)
            fallthrough
        case .級08:
            result.append(.級08)
            fallthrough
        case .級09:
            result.append(.級09)
            fallthrough
        case .級10:
            result.append(.級10)
        case .none: break
        }
        
        return result
    }
    
    private func availableWordLevels(for currentJLPTLevel: NouryokuLevel) -> [SchoolLevel] {
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
}
