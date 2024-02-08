//
//  KanjiKenteiStore.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/10/16.
//

import Foundation

class KanjiKankenStore: IStore {
    typealias Result = [KanjiKankenModel]
    typealias Entity = [KanjiKankenModel]
    
    private var data: [KanjiKankenModel] = []
    
    func updateAll(data: [KanjiKankenModel]) {
        self.data = data
    }
    
    func getAll() -> [KanjiKankenModel] {
        return data
    }
    
    func get(level: KankenLevel) -> [KanjiKankenModel] {
        return data.filter { $0.kankenLevel == level }
    }
    
    func clearAll() {
        data.removeAll()
    }
    
}
