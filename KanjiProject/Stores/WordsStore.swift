//
//  WordsStore.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/02/06.
//

import Foundation

class WordsStore: IStore, ObservableObject {
    typealias Result = [WordModel]
    typealias Entity = [WordModel]
    
    @Published private var data: [WordModel] = []
    
    init() {
        
    }
    
    func updateAll(data: [WordModel]) {
        self.data = data
    }
    
    func getAll() -> [WordModel] {
        data.sorted(by: { $0.body < $1.body })
    }
    
    func clearAll() {
        data.removeAll()
    }
    
    func getAll(for level: NouryokuLevel) -> [WordModel] {
        let result = data.filter { word in
            for lv in word.levelInTag where lv == level {
                return true
            }
            return false
        }
        return result
    }
    
    func saveInFileManager() async {
        let data = JSONManager.manager.encodeToJSON(data)
        JSONManager.manager.saveJSONToFile(data, fileName: .baseWords)
    }
    
    func saveInFileManager() {
        let data = JSONManager.manager.encodeToJSON(data)
        JSONManager.manager.saveJSONToFile(data, fileName: .baseWords)
    }
}

extension WordsStore {
    func saveInFileManager(fileName: JSONManager.FileName) async {
        let data = JSONManager.manager.encodeToJSON(data)
        JSONManager.manager.saveJSONToFile(data, fileName: fileName)
    }
}

extension WordsStore: IWord {
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
            print("Cant find word \(word.body)")
        }
    }
}
