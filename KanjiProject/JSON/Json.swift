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
        case kana = "Kana"
    }
    
    func encodeToJSON(kanji: [KanjiModel]) -> Data {
        var result = Data()
        do {
            let data = try JSONEncoder().encode(kanji)
            result = data
        } catch {
            print(error)
        }
        return result
    }
    
    func encodeToJSON(dictionary: [DictionaryModel]) -> Data {
        var result = Data()
        do {
            let data = try JSONEncoder().encode(dictionary)
            result = data
        } catch {
            print(error)
        }
        return result
    }
    
    func encodeToJSON(kana: [KanaModel]) -> Data {
        var result = Data()
        do {
            let data = try JSONEncoder().encode(kana)
            result = data
        } catch {
            print(error)
        }
        return result
    }
    
    private func decodeToKanjiModel(data: Data) -> [KanjiModel] {
        var result: [KanjiModel] = []
        let decoder = JSONDecoder()
        
        do {
            result = try decoder.decode([KanjiModel].self, from: data)
        } catch {
            print(error)
        }
        
        return result
    }
    
    private func decodeToDictionaryModel(data: Data) -> [DictionaryModel] {
        var result: [DictionaryModel] = []
        let decoder = JSONDecoder()
        
        do {
            result = try decoder.decode([DictionaryModel].self, from: data)
        } catch {
            print(error)
        }
        
        return result
    }
    
    private func decodeToKanaModel(data: Data) -> [KanaModel] {
        var result: [KanaModel] = []
        let decoder = JSONDecoder()
        
        do {
            result = try decoder.decode([KanaModel].self, from: data)
        } catch {
            print(error)
        }
        return result
    }
    
    
    ///   - МЕТОД ТОЛЬКО ДЛЯ СОЗДАНИЯ ФАЙЛА. В ЗОНЕ CТАНДАРТНОЙ РАБОТЫ ПРИЛОЖЕНИЯ НЕ ПРИМЕНЯТЬ
    ///   -
    ///   - ДОСТУП К ФАЙЛУ:  Finder -> (menu) go+option button -> Library -> остальной адрес можно увидеть в консоли)
    ///   -
    ///   - ДЕВАЙС: (В терминале написать) xcrun simctl list devices или в консоли посмотреть адрес
    func saveJSONToFile(data: Data, fileName: FileName) {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentDirectory.appendingPathComponent(fileName.rawValue, conformingTo: .json)
        
        do {
            try data.write(to: fileURL)
            print("JSON SAVED TO \(fileURL)")
        } catch {
            print(error)
        }
    }
    
    func getDictionaryData() -> [DictionaryModel] {
        guard let url = Bundle.main.url(forResource: FileName.dictionary.rawValue, withExtension: "json") else {
            print("Dictionary file not exist")
            return []
        }
        var result: [DictionaryModel] = []
         
        do {
            result = decodeToDictionaryModel(data: try Data(contentsOf: url))
        } catch {
            print(error)
        }
        return result
    }
    
    func getKanjiData() -> [KanjiModel] {
        guard let url = Bundle.main.url(forResource: FileName.kanji.rawValue, withExtension: "json") else {
            print("Kanji file not exist")
            return []
        }
        var result: [KanjiModel] = []
         
        do {
            result = decodeToKanjiModel(data: try Data(contentsOf: url))
        } catch {
            print(error)
        }
        return result
    }
    
    func getKanaData() -> [KanaModel] {
        var result: [KanaModel] = []
        
        guard let url = Bundle.main.url(forResource: FileName.kana.rawValue, withExtension: "json") else {
            print("Kana file not exist")
            return []
        }
        
        do {
            result = decodeToKanaModel(data: try Data(contentsOf: url))
        } catch {
            print(error)
        }
        return result
    }
}
