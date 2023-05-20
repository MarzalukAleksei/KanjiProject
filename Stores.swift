//
//  Stores.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/12.
//

import Foundation

class Stores: ObservableObject {
    var kanjistore = KanjiStore()
//    let kana = KanaStore()
//    let yojijukugo = Yojijukugo()
//    let bushu = Bushu() // ключи
    @Published var user = UserData(level: .beginer, dictionary: [])
    
    init() {
        loadData()
        user.dictionary = kanjistore.getData(.N5)
    }
    
    private func loadData() {
        do {
            let kanji = KanjiMapper().gettingData(entity: FileMapper().transform(data: try FileManager().loadFile(fileName: "Kanji", fileType: .csv)))
            
            kanjistore.updateAll(data: kanji)
//            kanjistore.update(data: kanji)
        } catch {
            print(error)
        }
    }
}
