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
    
    
    private var data: [KanjiModel] = []
    
    init() {
        
    }
    
    func getData() -> [KanjiModel] {
        return data
    }
    
    func update(data: [KanjiModel]) {
        self.data = data
    }
    
    func clearAll() {
        data.removeAll()
    }
}
