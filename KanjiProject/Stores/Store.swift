//
//  Store.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/24.
//

import SwiftUI

class Store: ObservableObject {
    @Published var kanjiStore = KanjiStore()
    @Published var dictionaryStore = DictionaryStore()
    
    init() {
        kanjiStore.updateAll(data: JSON.methoods.getKanjiData())
        dictionaryStore.updateAll(data: JSON.methoods.getDictionaryData())
    }
}


