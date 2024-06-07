//
//  BushuStore.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/05/27.
//

import Foundation

class BushuStore: IStore {
    
    typealias Result = [BushuModel]
    
    typealias Entity = [BushuModel]
    
    private var data: [BushuModel] = []
    
    func updateAll(data: [BushuModel]) {
        self.data = data
    }
    
    func getAll() -> [BushuModel] {
        data
    }
    
    func clearAll() {
        data.removeAll()
    }
    
    func saveInFileManager() async {
        let data = JSONManager.manager.encodeToJSON(data)
        JSONManager.manager.saveJSONToFile(data, fileName: .bushu)
    }
    
    var whatIsIt: String {
        """
        Данный раздел посвящен ключам.
        Ключи - это простые символы, помогающие установить область, к которой относится кандзи, или даже понять его значение.
        Для того чтобы научиться писатьи понимать кандзи, их необходимо выучить.
        Можно пропустить в начале, но начиная с N4 желательно запомнить все.
        """
    }
}
