//
//  KanjiKenteiStore.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/10/16.
//

import Foundation

class KanjiKenteiStore: IStore {
    typealias Result = [KanjiKenteiModel]
    typealias Entity = [KanjiKenteiModel]
    
    private var data: [KanjiKenteiModel] = []
    
    func updateAll(data: [KanjiKenteiModel]) {
        self.data = data
    }
    
    func getAll() -> [KanjiKenteiModel] {
        return data
    }
    
    func clearAll() {
        data.removeAll()
    }
    
    
    
}
