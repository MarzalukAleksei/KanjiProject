//
//  KanjiKankenExamplesTranslationsStore.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/06/20.
//

import Foundation

class KanjiKankenExamplesTranslationsStore: IStore {
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
        data = []
    }
    
    func saveInFileManager() async {
        let data = JSONManager.manager.encodeToJSON(data)
        JSONManager.manager.saveJSONToFile(data, fileName: .kanjiKankenExamplesTranslations)
    }
    
    func saveInFileManager() {
        let data = JSONManager.manager.encodeToJSON(data)
        JSONManager.manager.saveJSONToFile(data, fileName: .kanjiKankenExamplesTranslations)
    }
    
    func updateWord(_ word: WordModel) async {
        let index = data.firstIndex(where: { $0.id == word.id })
        if let index = index {
            data[index] = word
        }
    }
    
    func updateWord(_ word: WordModel) {
        let index = data.firstIndex(where: { $0.id == word.id })
        if let index = index {
            data[index] = word
        }
    }
    
    
}
