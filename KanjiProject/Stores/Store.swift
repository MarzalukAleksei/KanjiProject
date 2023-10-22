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
    @Published var giseigo = GiseigoStore()
    @Published var kanjiKentei = KanjiKenteiStore()
    
    init() {
        kanjiStore.updateAll(data: JSONManager.methoods.getKanji())
        dictionaryStore.updateAll(data: JSONManager.methoods.getDictionary())
        kanaStore.updateAll(data: JSONManager.methoods.getKana())
        yojijukugoStore.updateAll(data: JSONManager.methoods.getYojijukugo())
        giseigo.updateAll(data: JSONManager.methoods.getGiseigo())
        kanjiKentei.updateAll(data: JSONManager.methoods.getKanjiKentei())
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


