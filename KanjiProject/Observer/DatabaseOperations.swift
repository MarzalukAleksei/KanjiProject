//
//  DatabaseOperations.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/09/12.
//

import Foundation

class DatabaseOperations: ObservableObject {
    private let store: Store
    private let chosenLevel: NouryokuLevel
//    @Published private(set) var currentKanji: KanjiKankenModel?
//    @Published private(set) var availableKanji: [KanjiKankenModel] = []
    
    init(store: Store, chosenLevel: NouryokuLevel) {
        self.store = store
        self.chosenLevel = chosenLevel
    }
    
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
    
    func getAllSuitableKanjiArray() async -> [KanjiKankenModel] {
        var result: [KanjiKankenModel] = []
        let kanjiWithSuitableLevel = store.kanjiKankenStore.getAllKanji(below: chosenLevel)
        let kanjiInLearningList = kanjiWithSuitableLevel.filter { $0.isInLearningList() == true }
        var notYetLearned = Set(kanjiWithSuitableLevel.filter { $0.isInLearningList() == nil })
        var updatingKanji: [KanjiKankenModel] = []
        
        result = kanjiInLearningList.filter { kanji in
            let rightAnswers = kanji.rightAnwers ?? 0
            let minutePassed = Date.minutesPassed(from: kanji.getDate())
            
            if rightAnswers < 6, minutePassed >= 15 || kanji.getDate() == nil {
                return true
            }
            if rightAnswers < 11, minutePassed >= 60 {
                return true
            }
            
            return false
        }
        
        while result.count < 100, !notYetLearned.isEmpty {
            let kanji = notYetLearned.removeFirst()
            updatingKanji.append(kanji)
            result.append(kanji)
        }
        
        await updateKanji(array: updatingKanji)
        
        return result
    }
    
    private func availableWordLevels() -> [SchoolLevel] {
        var result: [SchoolLevel] = []
        switch chosenLevel {
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
