//
//  KanjiKenteiStore.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/10/16.
//

import Foundation

class KanjiKankenStore: IStore, ObservableObject {
    typealias Result = [KanjiKankenModel]
    typealias Entity = [KanjiKankenModel]
    
    @Published private var data: [KanjiKankenModel] = []
    
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
    
    func getAllKanji(below level: NouryokuLevel) -> [KanjiKankenModel] {
        var allCurrentLEvelKanji: [KanjiKankenModel] = []
        switch level {
        case .another:
            return []
        case .N1:
            allCurrentLEvelKanji.append(contentsOf: get(nouryokuLevel: .N1))
            fallthrough
        case .N2:
            allCurrentLEvelKanji.append(contentsOf: get(nouryokuLevel: .N2))
            fallthrough
        case .N3:
            allCurrentLEvelKanji.append(contentsOf: get(nouryokuLevel: .N3))
            fallthrough
        case .N4:
            allCurrentLEvelKanji.append(contentsOf: get(nouryokuLevel: .N4))
            fallthrough
        case .N5:
            allCurrentLEvelKanji.append(contentsOf: get(nouryokuLevel: .N5))
        }
        return allCurrentLEvelKanji
    }
    
    func update(set kanji: KanjiKankenModel) {
        if let index = data.firstIndex(where: { $0.body == kanji.body }) {
            data[index] = kanji
        } else {
            print("Check input Kanji")
        }
    }
    
//    func update(set kanji: KanjiKankenModel) async {
//        if let index = data.firstIndex(where: { $0.body == kanji.body }) {
//            data[index] = kanji
//        } else {
//            print("Check input Kanji")
//        }
//    }
}
