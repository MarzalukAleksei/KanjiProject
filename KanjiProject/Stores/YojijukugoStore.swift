//
//  YojijukugoStore.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/09/03.
//

import Foundation

class YojijukugoStore: IStore {
    
    typealias Result = [YojijukugoModel]
    typealias Entity = [YojijukugoModel]
    
    private var data: [YojijukugoModel] = []
    
    func clearAll() {
        data.removeAll()
    }
    
    func updateAll(data: [YojijukugoModel]) {
        self.data = data
    }
    
    func getAll() -> [YojijukugoModel] {
        return data
    }
    
}
