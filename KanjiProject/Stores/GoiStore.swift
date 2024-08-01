//
//  GoiStore.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/07/12.
//

import Foundation

class GoiStore: IStore {
    typealias Result = [WordModel]
    typealias Entity = [WordModel]
    
    private var data: [WordModel] = []
    
    func updateAll(data: [WordModel]) {
        self.data = data
    }
    
    func getAll() -> [WordModel] {
        data
    }
    
    func clearAll() {
        data.removeAll()
    }
    
    func saveInFileManager() async {
        let data = JSONManager.manager.encodeToJSON(data)
        JSONManager.manager.saveJSONToFile(data, fileName: .goi)
    }
    
    
    
}
