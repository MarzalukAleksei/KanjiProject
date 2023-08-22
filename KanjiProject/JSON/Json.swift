//
//  Json.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/22.
//

import SwiftUI


class JSON {
    
    static let methoods = JSON()
    
    enum FileName: String {
        case kanji = "Kanji"
        case dictionary = "Dictionary"
    }
    
    func encodeToString(kanji: [KanjiModel]) -> String {
        var result = ""
        do {
            let data = try JSONEncoder().encode(kanji)
            result = String(data: data, encoding: .utf8) ?? ""
        } catch {
            print(error)
        }
        return result
    }
    
    func encodeToString(dictionary: [DictionaryModel]) -> String {
        var result = ""
        do {
            let data = try JSONEncoder().encode(dictionary)
            result = String(data: data, encoding: .utf8) ?? ""
        } catch {
            print(error)
        }
        return result
    }
    
    func decodeToModel(text: String) -> [KanjiModel] {
        var result: [KanjiModel] = []
        let data = Data(text.utf8)
        let decoder = JSONDecoder()
        
        do {
            result = try decoder.decode([KanjiModel].self, from: data)
        } catch {
            print(error)
        }
        
        return result
    }
    
    func decodeToModel(text: String) -> [DictionaryModel] {
        var result: [DictionaryModel] = []
        let data = Data(text.utf8)
        let decoder = JSONDecoder()
        
        do {
            result = try decoder.decode([DictionaryModel].self, from: data)
        } catch {
            print(error)
        }
        
        return result
    }
    
    func saveToJSONFile(text: String, fileName: FileName) {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .userDirectory, in: .userDomainMask).first else { return }
        var fileName = fileName.rawValue
        let fileURL = documentDirectory.appendingPathComponent(fileName, conformingTo: .json)
        
        do {
            try text.write(to: fileURL, atomically: true, encoding: .utf8)
            print("JSON SAVED TO \(fileURL)")
        } catch {
            print(error)
        }
    }
}
