//
//  KanaStore.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/24.
//

import Foundation

class KanaStore: IStore {
    
    typealias Result = [KanaModel]
    typealias Entity = [KanaModel]
    
    private var data: [KanaModel] = []
    
    func updateAll(data: [KanaModel]) {
        self.data = data
    }
    
    func getAll() -> [KanaModel] {
        return data
    }
    
    func clearAll() {
        self.data.removeAll()
    }
}
