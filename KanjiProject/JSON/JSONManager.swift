//
//  Json.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/22.
//

import SwiftUI


class JSONManager {
    
    static let manager = JSONManager()
    
    enum FileName: String {
        case kanji = "Kanji"
        case dictionary = "Dictionary"
        case kana = "Kana"
        case yojijukugo = "Yojijukugo"
        case giseigo = "Giseigo"
        case kanjiKanken = "KanjiKanken"
        case baseWords = "BaseWords"
        case bushu = "Bushu"
        case wordsForKanjiExamples = "WordsForKanjiExamples"
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
    
    ///   - МЕТОД ДЛЯ СОЗДАНИЯ ФАЙЛА. 
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
    
}
