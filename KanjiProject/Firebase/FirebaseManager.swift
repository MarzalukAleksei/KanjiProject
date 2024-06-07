//
//  FirebaseManager.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/02/26.
//

import Foundation
import FirebaseStorage

class FirebaseManager {
    enum Links: String {
        case baseWords = "/BaseJsonFiles/BaseWords.json"
        case kankenKanji = "/BaseJsonFiles/KanjiKanken.json"
        case dictionary =  "/BaseJsonFiles/Dictionary.json"
        case kana = "/BaseJsonFiles/Kana.json"
        case yojijukugo = "/BaseJsonFiles/Yojijukugo.json"
        case giseigo = "BaseJsonFiles/Giseigo.json"
        case kanji = "BaseJsonFiles/Kanji.json"
        case bushu = "BaseJsonFiles/Bushu.json"
    }
    
    static let manager = FirebaseManager()
    
    private let storage = Storage.storage()
    private let storageRef: StorageReference
    
    init() {
        self.storageRef = storage.reference()
    }
    
    func baseWord(completion: @escaping (Result<Data, Error>) -> Void) {
        let baseWordRef = storageRef.child(Links.baseWords.rawValue)
        baseWordRef.loadData { result in
            completion(result)
        }
    }
    
    func downloadKankenKanji(completion: @escaping (Result<Data, Error>) -> Void) {
        let kankenRef = storageRef.child(Links.kankenKanji.rawValue)
        kankenRef.loadData { result in
            completion(result)
        }
    }
    
    func downloadDictionary(completion: @escaping (Result<Data, Error>) -> Void) {
        let dictionary = storageRef.child(Links.dictionary.rawValue)
        dictionary.loadData { result in
            completion(result)
        }
    }
    
    func downloadKana(completion: @escaping (Result<Data, Error>) -> Void) {
        let kana = storageRef.child(Links.kana.rawValue)
        kana.loadData { result in
            completion(result)
        }
    }
    
    func downloadYojijukugo(completion: @escaping (Result<Data, Error>) -> Void) {
        let yoji = storageRef.child(Links.yojijukugo.rawValue)
        yoji.loadData { result in
            completion(result)
        }
    }
    
    func downloadGiseigo(completion: @escaping (Result<Data, Error>) -> Void) {
        let giseigo = storageRef.child(Links.giseigo.rawValue)
        giseigo.loadData { result in
            completion(result)
        }
    }
    
    func downloadKanji(completion: @escaping (Result<Data, Error>) -> Void) {
        let kanji = storageRef.child(Links.kanji.rawValue)
        kanji.loadData { result in
            completion(result)
        }
    }
    
    func downloadBushu(completion: @escaping (Result<Data, Error>) -> Void) {
        let bushu = storageRef.child(Links.bushu.rawValue)
        bushu.loadData { result in
            completion(result)
        }
    }
    
}

extension StorageReference {
    func loadData(completion: @escaping (Result<Data, Error>) -> Void) {
        // Download in memory with a maximum allowed size of 30MB (1 * 1024 * 1024 bytes)
        self.getData(maxSize: 40 * 1024 * 1024) { data, error in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                completion(.success(data))
            }
        }
    }
}
