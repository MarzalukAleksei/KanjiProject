//
//  Stores.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/12.
//

import Foundation

class RefactoredStores {
//    static let shared = Stores()
    
    var kanjiStore = KanjiStore()
    var kanaStore = KanaStore()
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
            let kana = KanaMapper().gettingData(entity: FileMapper().transform(data: try FileManage().loadFile(fileName: "Kana", fileType: .csv)))
            
            kanjiStore.updateAll(data: kanji)
//            kanjistore.update(data: kanji)
            dictionaryStore.updateAll(data: dictionary)
            kanaStore.updateAll(data: kana)
        } catch {
            print(error)
        }
    }
}

extension RefactoredStores: ObservableObject {
    
}
