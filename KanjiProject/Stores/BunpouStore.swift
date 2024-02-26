//
//  BunpouStore.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/09/28.
//

import Foundation

class BunpouStore: IStore {
    typealias Result = [BunpouModel]
    typealias Entity = [BunpouModel]
    
    private var data: [BunpouModel] = []
    
    func updateAll(data: [BunpouModel]) {
        self.data = data
    }
    
    func getAll() -> [BunpouModel] {
        data
    }
    
    func getAll(of level: NouryokuLevel) -> [BunpouModel] {
        data.filter { $0.level == level }
    }
    
    func clearAll() {
        data.removeAll()
    }
    
    func saveInFileManager() async {
//        let data = JSONManager.manager.encodeToJSON(data)
//        JSONManager.manager.saveJSONToFile(data, fileName: .baseWords)
    }
}
