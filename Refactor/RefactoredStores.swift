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
    var dictionaryStore = DictionaryStore()
    var kanaStore = KanaStore()
    var yojijukugoStore = YojijukugoStore()
    var giseigoStore = GiseigoStore()
    var bunpouStore = BunpouStore()
//    let bushu = Bushu() // ключи
    
    init() {
        loadData()
    }
    
    private func loadData() {
        do {
            let kanji = KanjiMapper().gettingData(entity: FileMapper().transform(data: try FileManage().loadFile(fileName: "Kanji", fileType: .csv)))
            let dictionary = DictionaryMapper().gettingData(entity: FileMapper().transform(data: try FileManage().loadFile(fileName: "warodai", fileType: .txt)))
            let kana = KanaMapper().gettingData(entity: FileMapper().transform(data: try FileManage().loadFile(fileName: "Kana", fileType: .csv)))
            let yojijukugo = YojijukugoMapper().gettingData(entity: FileMapper().transform(data: try FileManage().loadFile(fileName: "Yojijukugo", fileType: .csv)))
            let giseigo = GiseigoMapper().gettingData(entity: FileMapper().transform(data: try FileManage().loadFile(fileName: "Giseigo", fileType: .csv)))
            let bunpou = BunpouMapper().gettingData(entity: FileMapper().transform(data: try FileManage().loadFile(fileName: "Bunpou", fileType: .csv)))
            
            kanjiStore.updateAll(data: kanji)
            dictionaryStore.updateAll(data: dictionary)
            kanaStore.updateAll(data: kana)
            yojijukugoStore.updateAll(data: yojijukugo)
            giseigoStore.updateAll(data: giseigo)
            bunpouStore.updateAll(data: bunpou)
            
        } catch {
            print(error)
        }
    }
}

extension RefactoredStores: ObservableObject {
    
}
