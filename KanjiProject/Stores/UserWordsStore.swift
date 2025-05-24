//
//  UserWordsStore.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2025/05/13.
//

import Foundation

class UserWordsStore: IStore {
    
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
        JSONManager.manager.saveJSONToFile(data, fileName: .usersWords)
    }
}

extension UserWordsStore: IWord {
    typealias Word = WordModel
    
    func update(set word: WordModel) {
        setWord(word)
    }
    
    func update(set word: WordModel) async {
        setWord(word)
    }
    
    func add(word: WordModel) {
        data.append(word)
    }
    
    func delete(_ word: WordModel) async {
        data.removeAll(where: { $0.id == word.id })
    }
    
    private func setWord(_ word: WordModel) {
        if let index = data.firstIndex(where: { $0.id == word.id }) {
            data[index] = word
        } else {
            print("Check word \(word.body)")
        }
    }
    
}
