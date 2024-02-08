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
    private var data: [KanjiModel] = []
    
    func get(_ level: NouryokuLevel) -> [KanjiModel] {
        data.filter { $0.level == level }
    }
    
    func getAll() -> [KanjiModel] {
        data
    }
    
    func updateAll(data: [KanjiModel]) {
        self.data = data.sorted(by: { $0.number < $1.number })
    }
    
    func clearAll() {
        data.removeAll()
    }
    
    func update(kanji: KanjiModel) {
        if let index = data.firstIndex(where: { $0.body == kanji.body }) {
            data[index].answer(set: kanji.lastAnswer())
        }
    }
}
