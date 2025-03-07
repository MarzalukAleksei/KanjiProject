//
//  Store.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/24.
//

import SwiftUI

/// Основное хранилище всех данных
final class Store: ObservableObject {
    /// старая база, УБРАТЬ
    @Published var kanjiStore = KanjiStore()
    /// База данных слов
    @Published var dictionaryStore = DictionaryStore()
    @Published var kanaStore = KanaStore()
    @Published var yojijukugoStore = YojijukugoStore()
    @Published var giseigoStore = GiseigoStore()
    /// Основная база данных по кандзи
    @Published var kanjiKankenStore = KanjiKankenStore()
    /// Слова которые необходимо выучить для свободного использовая японского
    @Published var baseWordsStore = WordsStore()
    @Published var bushuStore = BushuStore()
    /// Слова используемые в примерах
    @Published var kanjiKankenExamplesTranslationsStore = KanjiKankenExamplesTranslationsStore()
    @Published var goiStore = GoiStore()
    
    init() {
//        kanjiStore.updateAll(data: JSONManager.manager.getKanji())
//        dictionaryStore.updateAll(data: JSONManager.manager.getDictionary())
//        kanaStore.updateAll(data: JSONManager.manager.getKana())
//        yojijukugoStore.updateAll(data: JSONManager.manager.getYojijukugo())
//        giseigoStore.updateAll(data: JSONManager.manager.getGiseigo())
//        kanjiKankenStore.updateAll(data: JSONManager.manager.getKanjiKanken())
//        baseWordsStore.updateAll(data: JSONManager.manager.getBaseWords())
    }
    
    /// This methood update word in store, than save a file
    /// - Parameter word: given word
    func updateWord(_ word: WordModel) async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { [weak self] in
                self?.kanjiKankenExamplesTranslationsStore.updateWord(word)
                self?.kanjiKankenExamplesTranslationsStore.saveInFileManager()
            }
            group.addTask { [weak self] in
                self?.baseWordsStore.update(set: word)
                self?.baseWordsStore.saveInFileManager()
            }
            await group.waitForAll()
        }
    }
    
    func getAllWords() -> [WordModel] {
        baseWordsStore.getAll() + kanjiKankenExamplesTranslationsStore.getAll()
    }
    
    func getBaseWords() -> [WordModel] {
        baseWordsStore.getAll() /*+ dictionaryStore.getAll()*/
    }
    
    func updateAll(store: Store) {
        kanjiStore = store.kanjiStore
        dictionaryStore = store.dictionaryStore
        kanaStore = store.kanaStore
        yojijukugoStore = store.yojijukugoStore
        giseigoStore = store.giseigoStore
        kanjiKankenStore = store.kanjiKankenStore
        baseWordsStore = store.baseWordsStore
        bushuStore = store.bushuStore
        kanjiKankenExamplesTranslationsStore = store.kanjiKankenExamplesTranslationsStore
        goiStore = store.goiStore
    }
    
    /// Обновляем существующий кандзи
    func updateKanji(_ kanji: KanjiModel) {
        
//        DispatchQueue.global(qos: .background).async { [self] in
//            var newKanjiStore = kanjiStore.getAll()
//            
//            for (index, value) in kanjiStore.getAll().enumerated() where value.id == kanji.id {
//                newKanjiStore[index] = kanji
//            }
//            kanjiStore.updateAll(data: newKanjiStore)
//        }
        Task {
            var newKanjiStore = kanjiStore.getAll()
            
            for (index, value) in kanjiStore.getAll().enumerated() where value.id == kanji.id {
                newKanjiStore[index] = kanji
            }
            
            kanjiStore.updateAll(data: newKanjiStore)
        }
    }
    
}

extension Store {
    func findWordInBase(with components: [TextAndReading]) -> WordModel? {
        var word = ""
        for component in components {
            word += component.text
        }
        let result = getAllWords().first(where: { $0.body == word })
        return result
    }
}

extension Store {
    static let MOCK_STORE = setMockData()
    
    private static func setMockData() -> Store {
        let store = Store()
        store.kanjiKankenStore.updateAll(data: [.MOCK_KANJIKANKEN, .ANOTHER_MOCK_KANKENKANJI])
        store.baseWordsStore.updateAll(data: [.MOCK, .MOCK])
        store.kanjiKankenExamplesTranslationsStore.updateAll(data: [.MOCK, .MOCK])
        
        return store
    }
}
