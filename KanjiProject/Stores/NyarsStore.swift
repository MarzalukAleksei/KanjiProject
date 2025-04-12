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
    
    /// На данный момент ничего не делает
    func saveInFileManager() async { }
    
    func updateAll(data: [NyarsDatabaseModel]) {
        self.data = data
    }
    
    func getAll() -> [NyarsDatabaseModel] {
        data
    }
    
    func getWord(with id: UUID) throws -> NyarsDatabaseModel {
        guard let word = data.first(where: { $0.id == id }) else { throw MyErrors.wordIsNotAvailable }
        return word
    }
    
    func findWords(with row: String) async -> [NyarsDatabaseModel] {
        let result = await withTaskGroup(of: [NyarsDatabaseModel].self, returning: [NyarsDatabaseModel].self) { taskGroup in
            for type in Types.allCases {
                taskGroup.addTask {
                    self.filter(row: row, by: type)
                }
            }
            var results: [NyarsDatabaseModel] = []
            
            for await result in taskGroup {
                results.append(contentsOf: result)
            }
            return results
        }
        return Set(result).sorted(by: { $0.hashValue < $1.hashValue })
    }
}

extension NyarsStore {
    
    private enum Types: CaseIterable {
        case words, readings, readingsKana
    }
    
    private func filter(row: String, by type: Types) -> [NyarsDatabaseModel] {
        let result = data.filter { nyarsData in
            var array: [String] = []
            switch type {
            case .words:
                array = nyarsData.spellings
            case .readings:
                array = nyarsData.readings
            case .readingsKana:
                array = nyarsData.readingsInKana
            }
            let words = array.filter { $0.contains(row) }
            if words.isEmpty {
                return false
            }
            return true
        }
        return result
    }
    
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
