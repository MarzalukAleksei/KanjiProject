//
//  Stores.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/12.
//

import Foundation

class RefactoredStores {
//    static let shared = Stores()
    
    var kanjistore = KanjiStore()
//    let kana = KanaStore()
//    let yojijukugo = Yojijukugo()
//    let bushu = Bushu() // ключи
    var dictionaryStore = DictionaryStore()
    
    init() {
        loadData()
    }
    
    private func loadData() {
        do {
            let kanji = KanjiMapper().gettingData(entity: FileMapper().transform(data: try FileManage().loadFile(fileName: "Kanji", fileType: .csv)))
            let dictionary = DictionaryMapper().gettingData(entity: FileMapper().transform(data: try FileManage().loadFile(fileName: "warodai", fileType: .txt)))
            kanjistore.updateAll(data: kanji)
//            kanjistore.update(data: kanji)
            dictionaryStore.updateAll(data: dictionary)
        } catch {
            print(error)
        }
    }
}

extension RefactoredStores: ObservableObject {
    
}
