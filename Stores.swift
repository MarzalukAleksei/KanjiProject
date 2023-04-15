//
//  Stores.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/12.
//

import Foundation

class Stores: ObservableObject {
    let kanjistore = KanjiStore()
//    let kana = KanaStore()
    
    
    init() {
        loadData()
    }
    
    private func loadData() {
        do {
            let kanji = KanjiMapper().gettingData(entity: FileMapper().transform(data: try FileManager().loadFile(fileName: "Kanji", fileType: .csv)))
            
            
            kanjistore.update(data: kanji)
        } catch {
            print(error)
        }
    }
}
