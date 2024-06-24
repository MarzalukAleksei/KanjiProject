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
    
    func getJoinedAll() -> String {
        var result: String = ""
        for i in data {
            var row = ""
            row += i.hiragana
            row += i.katakana
            row += i.yaCombination
            row += i.yuCombination
            row += i.yoCombination
            result += row
        }
        result += "ー"
        return result
    }
    
    func saveInFileManager() async {
        let data = JSONManager.manager.encodeToJSON(data)
        JSONManager.manager.saveJSONToFile(data, fileName: .kana)
    }
}
