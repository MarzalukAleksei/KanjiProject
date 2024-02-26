//
//  Loading.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/02/26.
//

import Foundation

final class Loading: ObservableObject {
    @Published var baseWords: [WordModel] = []
    @Published var kanjiKanken: [KanjiKankenModel] = []
    @Published var dictionary: [DictionaryModel] = []
    @Published var giseigo: [GiseigoModel] = []
    @Published var kana: [KanaModel] = []
    @Published var kanji: [KanjiModel] = []
    @Published var yojijukugo: [YojijukugoModel] = []
    
    var complete: Bool {
        if !baseWords.isEmpty,
           !kanjiKanken.isEmpty,
           !dictionary.isEmpty,
           !giseigo.isEmpty,
           !kana.isEmpty,
           !kanji.isEmpty,
           !yojijukugo.isEmpty {
            return true
        }
        return false
    }
    
    
    func load() {
        loadBaseWord()
        loadKanken()
        loadDictionary()
        loadGiseigo()
        loadKana()
        loadKanji()
        loadYojijukugo()
    }
    
    func with(completion: (Result<Store, Error>) -> Void) {
        let store = Store()
        store.baseWordsStore.updateAll(data: baseWords)
        store.kanjiKankenStore.updateAll(data: kanjiKanken)
        store.dictionaryStore.updateAll(data: dictionary)
        store.giseigoStore.updateAll(data: giseigo)
        store.kanaStore.updateAll(data: kana)
        store.kanjiStore.updateAll(data: kanji)
        store.yojijukugoStore.updateAll(data: yojijukugo)
        
        completion(.success(store))
    }
    
    private func loadBaseWord() {
        let baseWord = getBaseWord()
        
        if baseWord.isEmpty {
            FirebaseManager.manager.baseWord { result in
                switch result {
                case .success(let data):
                    guard let words: [WordModel] = JSONManager.manager.decodeToModel(data) else { return }
                    self.baseWords = words
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            self.baseWords = baseWord
        }
    }
    
    private func loadKanken() {
        let kanken = getKanken()
        
        if kanken.isEmpty {
            FirebaseManager.manager.downloadKankenKanji { result in
                switch result {
                case .success(let data):
                    guard let kanken: [KanjiKankenModel] = JSONManager.manager.decodeToModel(data) else { return }
                    self.kanjiKanken = kanken
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            self.kanjiKanken = kanken
        }
    }
    
    private func loadDictionary() {
        let dictionary = getDictionary()
        
        if dictionary.isEmpty {
            FirebaseManager.manager.downloadDictionary { result in
                switch result {
                case .success(let data):
                    guard let dictionary: [DictionaryModel] = JSONManager.manager.decodeToModel(data) else { return }
                    self.dictionary = dictionary
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            self.dictionary = dictionary
        }
    }
    
    private func loadGiseigo() {
        let giseigo = getGiseigo()
            
        if giseigo.isEmpty {
            FirebaseManager.manager.downloadGiseigo { result in
                switch result {
                case .success(let data):
                    guard let giseigo: [GiseigoModel] = JSONManager.manager.decodeToModel(data) else { return }
                    self.giseigo = giseigo
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            self.giseigo = giseigo
        }
    }
    
    private func loadKana() {
        let kana = getKana()
        
        if kana.isEmpty {
            FirebaseManager.manager.downloadKana { result in
                switch result {
                case .success(let data):
                    guard let kana: [KanaModel] = JSONManager.manager.decodeToModel(data) else { return }
                    self.kana = kana
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            self.kana = kana
        }
    }

    private func loadKanji() {
        let kanji = getKanji()
        
        if kanji.isEmpty {
            FirebaseManager.manager.downloadKanji { result in
                switch result {
                case .success(let data):
                    guard let kanji: [KanjiModel] = JSONManager.manager.decodeToModel(data) else { return }
                    self.kanji = kanji
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            self.kanji = kanji
        }
    }

    private func loadYojijukugo() {
        let yojijukugo = getYojijukugo()
        
        if yojijukugo.isEmpty {
            FirebaseManager.manager.downloadYojijukugo { result in
                switch result {
                case .success(let data):
                    guard let yojijukugo: [YojijukugoModel] = JSONManager.manager.decodeToModel(data) else { return }
                    self.yojijukugo = yojijukugo
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            self.yojijukugo = yojijukugo
        }
    }
    
    private func getBaseWord() -> [WordModel] {
        guard let data = Data.myFile(.baseWords),
              let result: [WordModel] = JSONManager.manager.decodeToModel(data) else { return [] }
        return result
    }
    
    private func getKanken() -> [KanjiKankenModel] {
        guard let data = Data.myFile(.kanjiKanken),
              let result: [KanjiKankenModel] = JSONManager.manager.decodeToModel(data) else { return [] }
        return result
    }
    
    private func getKanji() -> [KanjiModel] {
        guard let data = Data.myFile(.kanji),
              let result: [KanjiModel] = JSONManager.manager.decodeToModel(data) else { return [] }
        return result
    }
    
    private func getDictionary() -> [DictionaryModel] {
        guard let data = Data.myFile(.dictionary),
              let result: [DictionaryModel] = JSONManager.manager.decodeToModel(data) else { return [] }
        return result
    }
    
    private func getGiseigo() -> [GiseigoModel] {
        guard let data = Data.myFile(.giseigo),
              let result: [GiseigoModel] = JSONManager.manager.decodeToModel(data) else { return [] }
        return result
    }
    
    private func getKana() -> [KanaModel] {
        guard let data = Data.myFile(.kana),
              let result: [KanaModel] = JSONManager.manager.decodeToModel(data) else { return [] }
        return result
    }
    
    private func getYojijukugo() -> [YojijukugoModel] {
        guard let data = Data.myFile(.yojijukugo),
              let result: [YojijukugoModel] = JSONManager.manager.decodeToModel(data) else { return [] }
        return result
    }
}
