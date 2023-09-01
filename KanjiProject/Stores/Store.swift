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
    
    init() {
//        kanjiStore.updateAll(data: JSON.methoods.getKanjiData())
        kanjiStore.updateAll(data: JSON.methoods.loadSavedKanji())
        dictionaryStore.updateAll(data: JSON.methoods.getDictionaryData())
        kanaStore.updateAll(data: JSON.methoods.getKanaData())
    }
    
    func updateKanji(_ kanji: KanjiModel) {
        let backgroundThried = DispatchQueue(label: "background", qos: .background, attributes: .concurrent)
        
        backgroundThried.async { [self] in
            var newKanjiStore = kanjiStore.getAll()
            
            for (index, value) in kanjiStore.getAll().enumerated() where value.id == kanji.id {
                newKanjiStore[index] = kanji
            }
            kanjiStore.updateAll(data: newKanjiStore)
        }
    }
}


