//
//  WordsStore.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/02/06.
//

import Foundation

class WordsStore: IStore {
    typealias Result = [WordModel]
    typealias Entity = [WordModel]
    
    private var data: [WordModel] = []
    
    func updateAll(data: [WordModel]) {
        self.data = data
    }
    
    func getAll() -> [WordModel] {
        data.sorted(by: { $0.body < $1.body })
    }
    
    func clearAll() {
        data.removeAll()
    }
    
    func get(level: NouryokuLevel) -> [WordModel] {
        let result = data.filter { word in
            for lv in word.levelInTag where lv == level {
                return true
            }
            return false
        }
        return result
    }
    
    func update(set word: WordModel) {
        if let index = data.firstIndex(where: { $0.id == word.id }) {
            data[index] = word
        } else {
            print("Cant find word")
        }
    }
    
    func delete(_ word: WordModel) async {
        data.removeAll(where: { $0.id == word.id })
        
    }
}
