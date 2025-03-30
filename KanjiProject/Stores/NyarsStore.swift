//
//  NyarsStore.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2025/03/27.
//

import Foundation

class NyarsStore: IStore {
    typealias Result = [NyarsDatabaseModel]
    typealias Entity = [NyarsDatabaseModel]
    private var data: [NyarsDatabaseModel] = []
    
    init() {
        data = load()
    }
    
    func clearAll() {
        data.removeAll()
    }
    
    func saveInFileManager() async {
        
    }
    
    func updateAll(data: [NyarsDatabaseModel]) {
        self.data = data
    }
    
    func getAll() -> [NyarsDatabaseModel] {
        data
    }
    
}

extension NyarsStore {
    private func load() -> [NyarsDatabaseModel] {
        var result: [NyarsDatabaseModel] = []
        for number in 1...7 {
            guard let fileURL = Bundle.main.path(forResource: "terms_\(number)", ofType: "json") else { continue }
            let url = URL(fileURLWithPath: fileURL)
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                result += try decoder.decode([NyarsDatabaseModel].self, from: data)
            } catch {
                print(error)
            }
        }
        return result
    }
}
