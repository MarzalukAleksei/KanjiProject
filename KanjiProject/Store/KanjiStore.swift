//
//  KanjiStore.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/12.
//

import Foundation

class KanjiStore: IStore {
    typealias Result = [KanjiModel]
    typealias Entity = [KanjiModel]
    
//    private var data: [KanjiModel] = []
    private var data: [Level: [KanjiModel]] = [:]
    
//    func getData() -> [KanjiModel] {
//        return data
//    }
    
    func getData(_ level: Level) -> [KanjiModel] {
        guard let data = data[level] else { return [] }
        return data
    }
    
    func getAll() -> [KanjiModel] {
        var result: [KanjiModel] = []
        for i in data {
            result.append(contentsOf: i.value)
        }
        return result
    }
    
//    func update(data: [KanjiModel]) {
//        self.data = data
//    }
    
    func update(_ level: Level, data: [KanjiModel]) {
        self.data[level] = data
    }
    
    func updateAll(data: [KanjiModel]) {
        for level in Level.allCases {
            self.data[level] = data.filter { $0.level == level.rawValue }
        }
    }
    
    func clearAll() {
        data.removeAll()
    }
}
