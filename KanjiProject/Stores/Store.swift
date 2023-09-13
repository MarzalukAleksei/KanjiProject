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
    
    init() {
        kanjiStore.updateAll(data: JSON.methoods.getKanji())
        dictionaryStore.updateAll(data: JSON.methoods.getDictionary())
        kanaStore.updateAll(data: JSON.methoods.getKana())
        yojijukugoStore.updateAll(data: JSON.methoods.getYojijukugo())
        giseigo.updateAll(data: JSON.methoods.getGiseigo())
    }
    
    func updateKanji(_ kanji: KanjiModel) {
        
        DispatchQueue.global(qos: .background).async { [self] in
            var newKanjiStore = kanjiStore.getAll()
            
            for (index, value) in kanjiStore.getAll().enumerated() where value.id == kanji.id {
                newKanjiStore[index] = kanji
            }
            kanjiStore.updateAll(data: newKanjiStore)
        }
    }
    
}


