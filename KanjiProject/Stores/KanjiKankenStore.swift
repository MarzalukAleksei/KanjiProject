//
//  KanjiKenteiStore.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/10/16.
//

import Foundation

class KanjiKankenStore: IStore {
    typealias Result = [KanjiKankenModel]
    typealias Entity = [KanjiKankenModel]
    
    private var data: [KanjiKankenModel] = []
    
    func updateAll(data: [KanjiKankenModel]) {
        self.data = data
    }
    
    func getAll() -> [KanjiKankenModel] {
        return data
    }
    
    func get(kankenLevel level: KankenLevel) -> [KanjiKankenModel] {
        return data.filter { $0.kankenLevel == level }
    }
    
    func get(nouryokuLevel level: NouryokuLevel) -> [KanjiKankenModel] {
        return data.filter { $0.nouryokuLevel == level }
    }
    
    func clearAll() {
        data.removeAll()
    }
    
    func saveInFileManager() async {
        let data = JSONManager.manager.encodeToJSON(data)
        JSONManager.manager.saveJSONToFile(data, fileName: .kanjiKanken)
    }
    
    func update(set kanji: KanjiKankenModel) {
        if let index = data.firstIndex(where: { $0.body == kanji.body }) {
            data[index] = kanji
        } else {
            print("Check input Kanji")
        }
    }
}
