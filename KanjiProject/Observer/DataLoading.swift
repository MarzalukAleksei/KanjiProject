//
//  DataLoading.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/02/26.
//

import Foundation

final class DataLoading: ObservableObject {
    @Published var baseWords: [WordModel] = []
    @Published var kanjiKanken: [KanjiKankenModel] = []
    @Published var dictionary: [DictionaryModel] = []
    @Published var giseigo: [GiseigoModel] = []
    @Published var kana: [KanaModel] = []
    @Published var kanji: [KanjiModel] = []
    @Published var yojijukugo: [YojijukugoModel] = []
    @Published var bushu: [BushuModel] = []
    @Published var kanjiKankenExamplesTranslations: [WordModel] = []
    
    var complete: Bool {
        if !baseWords.isEmpty,
           !kanjiKanken.isEmpty,
           !dictionary.isEmpty,
           !giseigo.isEmpty,
           !kana.isEmpty,
           !kanji.isEmpty,
           !yojijukugo.isEmpty,
           !bushu.isEmpty,
           !kanjiKankenExamplesTranslations.isEmpty {
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
        loadBushu()
        loadKanjiKankenExamplesTranslations()
    }
    
    func data(with completion: (Result<Store, Error>) -> Void) {
        let store = Store()
        store.baseWordsStore.updateAll(data: baseWords)
        store.kanjiKankenStore.updateAll(data: kanjiKanken)
        store.dictionaryStore.updateAll(data: dictionary)
        store.giseigoStore.updateAll(data: giseigo)
        store.kanaStore.updateAll(data: kana)
        store.kanjiStore.updateAll(data: kanji)
        store.yojijukugoStore.updateAll(data: yojijukugo)
        store.bushuStore.updateAll(data: bushu)
        store.kanjiKankenExamplesTranslationsStore.updateAll(data: kanjiKankenExamplesTranslations)
        
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
                    Task {
                        let baseWordStore = WordsStore()
                        baseWordStore.updateAll(data: words)
                        await baseWordStore.saveInFileManager()
                    }
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
                    Task {
                        let kanjiKankenStore = KanjiKankenStore()
                        kanjiKankenStore.updateAll(data: kanken)
                        await kanjiKankenStore.saveInFileManager()
                    }
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
                    Task {
                        let dictionaryStore = DictionaryStore()
                        dictionaryStore.updateAll(data: dictionary)
                        await dictionaryStore.saveInFileManager()
                    }
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
                    Task {
                        let giseigoStore = GiseigoStore()
                        giseigoStore.updateAll(data: giseigo)
                        await giseigoStore.saveInFileManager()
                    }
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
                    Task {
                        let kanaStore = KanaStore()
                        kanaStore.updateAll(data: kana)
                        await kanaStore.saveInFileManager()
                    }
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
                    Task {
                        let kanjiStore = KanjiStore()
                        kanjiStore.updateAll(data: kanji)
                        await kanjiStore.saveInFileManager()
                    }
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
                    Task {
                        let yojijukuStore = YojijukugoStore()
                        yojijukuStore.updateAll(data: yojijukugo)
                        await yojijukuStore.saveInFileManager()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            self.yojijukugo = yojijukugo
        }
    }
    
    private func loadBushu() {
        var bushu = getBushu()
        
        if bushu.isEmpty {
            FirebaseManager.manager.downloadBushu { result in
                switch result {
                case .success(let data):
                    guard let bushu: [BushuModel] = JSONManager.manager.decodeToModel(data) else { return }
                    self.bushu = bushu
                    Task {
                        let bushuStore = BushuStore()
                        bushuStore.updateAll(data: bushu)
                        await bushuStore.saveInFileManager()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            self.bushu = bushu
        }
    }
    
    private func loadKanjiKankenExamplesTranslations() {
        var translations = getLoadKanjiKankenExamplesTranslations()
        
        if translations.isEmpty {
            FirebaseManager.manager.downloadKanjiKankenExamplesTranslations { result in
                switch result {
                case .success(let data):
                    guard let translations: [WordModel] = JSONManager.manager.decodeToModel(data) else { return }
                    self.kanjiKankenExamplesTranslations = translations
                    Task {
                        let translationsStore = KanjiKankenExamplesTranslationsStore()
                        translationsStore.updateAll(data: translations)
                        await translationsStore.saveInFileManager()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            self.kanjiKankenExamplesTranslations = translations
        }
    }
    
    /*private*/ func getLoadKanjiKankenExamplesTranslations() -> [WordModel] {
        guard let data = Data.myFile(.kanjiKankenExamplesTranslations),
              let result: [WordModel] = JSONManager.manager.decodeToModel(data) else { return [] }
        return result
    }
    
    private func getBushu() -> [BushuModel] {
        guard let data = Data.myFile(.bushu),
              let result: [BushuModel] = JSONManager.manager.decodeToModel(data) else { return [] }
        return result
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
