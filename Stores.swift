//
//  Stores.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/12.
//

import Foundation

class Stores: ObservableObject {
    @Published var kanjistore = KanjiStore()
//    let kana = KanaStore()
//    let yojijukugo = Yojijukugo()
    
    init() {
        loadData()
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
