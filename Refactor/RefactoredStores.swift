//
//  Stores.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/12.
//

import Foundation

class RefactoredStores {
//    static let shared = Stores()
    
    var kanjiStore = KanjiStore()
    var dictionaryStore = DictionaryStore()
    var kanaStore = KanaStore()
    var yojijukugoStore = YojijukugoStore()
    var giseigoStore = GiseigoStore()
    var bunpouStore = BunpouStore()
    var kanjiKenteiStore = KanjiKenteiStore()
//    let bushu = Bushu() // ключи
    
    init() {
        loadData()
    }
    
    private func loadData() {
        do {
            let kanji = KanjiMapper().gettingData(entity: FileMapper().transform(data: try FileManage().loadFile(fileName: "Kanji", fileType: .csv)))
            let dictionary = DictionaryMapper().gettingData(entity: FileMapper().transform(data: try FileManage().loadFile(fileName: "warodai", fileType: .txt)))
            let kana = KanaMapper().gettingData(entity: FileMapper().transform(data: try FileManage().loadFile(fileName: "Kana", fileType: .csv)))
            let yojijukugo = YojijukugoMapper().gettingData(entity: FileMapper().transform(data: try FileManage().loadFile(fileName: "Yojijukugo", fileType: .csv)))
            let giseigo = GiseigoMapper().gettingData(entity: FileMapper().transform(data: try FileManage().loadFile(fileName: "Giseigo", fileType: .csv)))
            let bunpou = BunpouMapper().gettingData(entity: FileMapper().transform(data: try FileManage().loadFile(fileName: "Bunpou", fileType: .csv)))
            let kanjiKentei = loadKanjiKentei()
            
            kanjiStore.updateAll(data: kanji)
            dictionaryStore.updateAll(data: dictionary)
            kanaStore.updateAll(data: kana)
            yojijukugoStore.updateAll(data: yojijukugo)
            giseigoStore.updateAll(data: giseigo)
            bunpouStore.updateAll(data: bunpou)
//            kanjiKenteiStore.updateAll(data: kanjiKentei)
            kanjiKenteiStore.updateAll(data: updateKanji(kana: kana, kanjiKentei: kanjiKentei))
            
        } catch {
            print(error)
        }
    }
    
    private func loadKanjiKentei() -> [KanjiKenteiModel]{
        var result: [KanjiKenteiModel] = []
        for name in KenteiLevel.allCases {
            result += getKanjiKentei(name: name.rawValue)
        }
        return result
    }
    
    private func getKanjiKentei(name: String) -> [KanjiKenteiModel] {
        do {
            return KanjiKenteiMapper().gettingData(entity: FileMapper().transform(data: try FileManage().loadFile(fileName: name, fileType: .txt)))
        } catch {
            print("\(name)")
        }
        return []
    }
    
    /// Устанавливаем Кун и Он чтения для каждого кандзи
    private func updateKanji(kana: [KanaModel], kanjiKentei: [KanjiKenteiModel]) -> [KanjiKenteiModel] {
        var result: [KanjiKenteiModel] = []
        for kanji in kanjiKentei {
            let array = kanji.defaultReading.components(separatedBy: "    ")
            var newKanji = kanji
            if array.count > 1 {
                newKanji.kunReading = KanjiKenteiMapper().getTypeValue(array[1])
                newKanji.onReading = KanjiKenteiMapper().getTypeValue(array[0])
                result.append(newKanji)
            } else {
                let row = KanjiKenteiMapper().getTypeValue(array[0])
                if let firstChar = row.first?.value.first {
                    if kana.contains(where: { $0.hiragana == String(firstChar)}) {
                        newKanji.kunReading = row
                    } else {
                        newKanji.onReading = row
                    }
                    result.append(newKanji)
                }
            }
        }
        return result
    }
}

extension RefactoredStores: ObservableObject {
    
}
