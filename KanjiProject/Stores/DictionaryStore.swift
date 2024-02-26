//
//  DictionaryStore.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/06/22.
//

import Foundation

class DictionaryStore: IStore {
    typealias Result = [DictionaryModel]
    typealias Entity = [DictionaryModel]
    
    private var data: [DictionaryModel] = []
    
    func updateAll(data: [DictionaryModel]) {
        self.data = data
    }
    
    func getAll() -> [DictionaryModel] {
        return data
    }
    
    func clearAll() {
        data.removeAll()
    }
    
    func saveInFileManager() async {
        let data = JSONManager.manager.encodeToJSON(data)
        JSONManager.manager.saveJSONToFile(data, fileName: .dictionary)
    }
    
    
}
