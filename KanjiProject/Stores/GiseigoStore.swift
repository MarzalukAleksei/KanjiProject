//
//  GiseigoStore.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/09/13.
//

import Foundation

class GiseigoStore: IStore {
    typealias Result = [GiseigoModel]
    typealias Entity = [GiseigoModel]
    
    private var data: [GiseigoModel] = []
    
    func updateAll(data: [GiseigoModel]) {
        self.data = data
    }
    
    func getAll() -> [GiseigoModel] {
        return data
    }
    
    func clearAll() {
        data.removeAll()
    }
    
    
    
    
}
