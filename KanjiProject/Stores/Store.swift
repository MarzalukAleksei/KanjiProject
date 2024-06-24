//
//  Store.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/24.
//

import SwiftUI

final class Store: ObservableObject {
    @Published var kanjiStore = KanjiStore()
    @Published var dictionaryStore = DictionaryStore()
    @Published var kanaStore = KanaStore()
    @Published var yojijukugoStore = YojijukugoStore()
    @Published var giseigoStore = GiseigoStore()
    @Published var kanjiKankenStore = KanjiKankenStore()
    @Published var baseWordsStore = WordsStore()
    @Published var bushuStore = BushuStore()
    @Published var kanjiKankenExamplesTranslationsStore = KanjiKankenExamplesTranslationsStore()
    
    init() {
//        kanjiStore.updateAll(data: JSONManager.manager.getKanji())
//        dictionaryStore.updateAll(data: JSONManager.manager.getDictionary())
//        kanaStore.updateAll(data: JSONManager.manager.getKana())
//        yojijukugoStore.updateAll(data: JSONManager.manager.getYojijukugo())
//        giseigoStore.updateAll(data: JSONManager.manager.getGiseigo())
//        kanjiKankenStore.updateAll(data: JSONManager.manager.getKanjiKanken())
//        baseWordsStore.updateAll(data: JSONManager.manager.getBaseWords())
    }
    
    func getAllWords() -> [WordModel] {
        baseWordsStore.getAll() + kanjiKankenExamplesTranslationsStore.getAll()
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


