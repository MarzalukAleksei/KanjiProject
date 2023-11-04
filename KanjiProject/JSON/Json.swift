//
//  Json.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/22.
//

import SwiftUI


class JSONManager {
    
    static let methoods = JSONManager()
    
    enum FileName: String {
        case kanji = "Kanji"
        case dictionary = "Dictionary"
        case kana = "Kana"
        case yojijukugo = "Yojijukugo"
        case giseigo = "Giseigo"
        case kanjiKanken = "KanjiKanken"
    }
    
    func encodeToJSON<T: Encodable>(_ model: T) -> Data {
        do {
            return try JSONEncoder().encode(model)
        } catch {
            print(error)
        }
        return Data()
    }
    
    func decodeToModel<T: Decodable>(_ data: Data) -> T? {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print(error)
        }
        return nil
    }
    
    ///   - МЕТОД ТОЛЬКО ДЛЯ СОЗДАНИЯ ФАЙЛА. В ЗОНЕ CТАНДАРТНОЙ РАБОТЫ ПРИЛОЖЕНИЯ НЕ ПРИМЕНЯТЬ
    ///   -
    ///   - ДОСТУП К ФАЙЛУ:  Finder -> (menu) go+option button -> Library -> остальной адрес можно увидеть в консоли)
    ///   -
    ///   - ДЕВАЙС: (В терминале написать) xcrun simctl list devices или в консоли посмотреть адрес
    func saveJSONToFile(_ data: Data, fileName: FileName) {
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
    
    func getDictionary() -> [DictionaryModel] {
        guard let url = Bundle.main.url(forResource: FileName.dictionary.rawValue, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let result: [DictionaryModel] = decodeToModel(data) else {
            
            print("Dictionary Json file not exist")
            return []
        }
        
        return result
    }
    
    private func getKanjiFromRootBundle() -> [KanjiModel] {
        guard let url = Bundle.main.url(forResource: FileName.kanji.rawValue, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let result: [KanjiModel] = decodeToModel(data) else {
            print("Kanji file not exist")
            return []
        }
        
        return result
    }
    
    func getYojijukugo() -> [YojijukugoModel] {
        guard let url = Bundle.main.url(forResource: FileName.yojijukugo.rawValue, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let result: [YojijukugoModel] = decodeToModel(data) else {
            print("Yojijukugo Json file not exist")
            return []
        }
        
        return result
    }
    
    func getKana() -> [KanaModel] {
        guard let url = Bundle.main.url(forResource: FileName.kana.rawValue, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let result: [KanaModel] = decodeToModel(data) else {
            print("Kana Json file not exist")
            return []
        }
        
        return result
    }
    
    func getKanji() -> [KanjiModel] {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(FileName.kanji.rawValue).json")
        guard let data = try? Data(contentsOf: url),
              let result: [KanjiModel] = decodeToModel(data) else {
            
            return getKanjiFromRootBundle()
        }
        
        return result
    }
    
    func getGiseigo() -> [GiseigoModel] {
        guard let url = Bundle.main.url(forResource: FileName.giseigo.rawValue, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let result: [GiseigoModel] = decodeToModel(data) else {
            print("Giseigo Json File Not Exist")
            return []
        }
        
        return result
    }
    
    func getKanjiKanken() -> [KanjiKankenModel] {
        guard let url = Bundle.main.url(forResource: FileName.kanjiKanken.rawValue, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let result: [KanjiKankenModel] = decodeToModel(data) else {
            print("KanjiKentei Json File Not Exist")
            return []
        }
        
        return result
    }
}
