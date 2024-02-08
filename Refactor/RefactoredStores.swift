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
    var kanjiKankenStore = KanjiKankenStore()
    var wordsStore = WordsStore()
//    let bushu = Bushu() // ключи
    
    init() async {
        await loadData()
    }
    
    private func loadData() async {
        do {
            let kanji = KanjiMapper().gettingData(entity: FileMapper().transform(data: try FileManage().loadFile(fileName: "Kanji", fileType: .csv)))
            let dictionary = DictionaryMapper().gettingData(entity: FileMapper().transform(data: try FileManage().loadFile(fileName: "warodai", fileType: .txt)))
            let kana = KanaMapper().gettingData(entity: FileMapper().transform(data: try FileManage().loadFile(fileName: "Kana", fileType: .csv)))
            let yojijukugo = YojijukugoMapper().gettingData(entity: FileMapper().transform(data: try FileManage().loadFile(fileName: "Yojijukugo", fileType: .csv)))
            let giseigo = GiseigoMapper().gettingData(entity: FileMapper().transform(data: try FileManage().loadFile(fileName: "Giseigo", fileType: .csv)))
            let bunpou = BunpouMapper().gettingData(entity: FileMapper().transform(data: try FileManage().loadFile(fileName: "Bunpou", fileType: .csv)))
//            let kanjiReplacer = loadKankenReplacer()
            let kanjiKanken = await loadAllKanken()
            let words = await loadAllWords()
            
            kanjiStore.updateAll(data: kanji)
            dictionaryStore.updateAll(data: dictionary)
            kanaStore.updateAll(data: kana)
            yojijukugoStore.updateAll(data: yojijukugo)
            giseigoStore.updateAll(data: giseigo)
            bunpouStore.updateAll(data: bunpou)
            kanjiKankenStore.updateAll(data: kanjiKanken.sorted { $0.id < $1.id } )
            wordsStore.updateAll(data: words)
//            kanjiKankenStore.updateAll(data: updateKanji(kana: kana, kanjiKentei: createKanjiKankenArray(allKanji: kanjiReplacer)))
            
        } catch {
            print(error)
        }
    }
    
    private func loadAllKanken() async -> [KanjiKankenModel] {
        let result = await withTaskGroup(of: [KanjiKankenModel].self, returning: [KanjiKankenModel].self) { taskGroup in
            for level in KankenLevel.allCases {
                taskGroup.addTask {
                    do {
                        let task = KankenMapper().gettingData(entity: FileMapper().transform(data: try FileManage().loadFile(fileName: level.rawValue, fileType: .txt)))
                        return task
                    } catch {
                        print(error)
                        return []
                    }
                }
            }
            
            var finalResult: [KanjiKankenModel] = []
            
            for await partialResult in taskGroup {
                finalResult.append(contentsOf: partialResult)
            }
            
            return finalResult
        }
        
        return result
    }
    
    private func loadAllWords() async -> [WordModel] {
        let result = await withTaskGroup(of: [WordModel].self, returning: [WordModel].self) { taskGroup in
            for file in WordsFilesNames.allCases {
                taskGroup.addTask {
                    do {
                        let task = WordMapper().gettingData(entity: FileMapper().transform(data: try FileManage().loadFile(fileName: file.rawValue, fileType: .txt)))
                        return task
                    } catch {
                        print(error)
                        return []
                    }
                }
            }
            var finalResult: [WordModel] = []
            
            for await result in taskGroup {
                finalResult.append(contentsOf: result)
            }
            return finalResult
        }
        return result
    }
    
}

extension RefactoredStores {
    enum WordsFilesNames: String, CaseIterable {
        case N1 = "Core Japanese Vocabulary__JLPT N1"
        case N2 = "Core Japanese Vocabulary__JLPT N2"
        case N3 = "Core Japanese Vocabulary__JLPT N3"
        case N4 = "Core Japanese Vocabulary__JLPT N4"
        case N5 = "Core Japanese Vocabulary__JLPT N5"
    }
}

extension RefactoredStores: ObservableObject {
    
    private func createKanjiKankenArray(allKanji: [KankenReplacer]) -> [KanjiKankenModel] {
        var result: [KanjiKankenModel] = []
        for (index, currentKanji) in allKanji.enumerated() {
            print("\(index + 1), -- \(allKanji.count)")
            let textAndReadings = getRowWithReadingAndText(allKanji: allKanji, currentKanji: currentKanji)
            result.append(KanjiKankenModel(id: 0,
                                           body: currentKanji.body,
                                           defaultReading: currentKanji.defaultReading,
                                           kunReading: currentKanji.kunReading,
                                           onReading: currentKanji.onReading,
                                           examples: currentKanji.examples,
                                           examplesWithReading: textAndReadings,
                                           meaning: currentKanji.meaning,
                                           keys: currentKanji.keys,
                                           kankenLevel: currentKanji.kankenLevel,
                                           stroke: currentKanji.stroke, link: ""))
        }
        return result
    }
    
    private func getRowWithReadingAndText(allKanji: [KankenReplacer], currentKanji: KankenReplacer) -> [SchoolLevel: [[TextAndReading]]] {
        var result: [SchoolLevel: [[TextAndReading]]] = [:]
        let exampleWithType = getExampleKanjiWithType(allKanji: allKanji, currentKanji: currentKanji)
        
        for element in currentKanji.examplesWithReading {
            // разделяет строку на массив если там есть ・
            let separateRow = element.value.components(separatedBy: "・")
            // преобразует массив в двумерный убирая все кроме кандзи
            let twoDemArray = getTwodemensionArray(separateRow, allKanji)
            // возвращает массив истоящий из массивов кандзи с окуриганой и без для разделения на чтение и без
            let separated = separated(separatedRow: separateRow, twoDemArray: twoDemArray)
            
            if let example = exampleWithType[element.key] {
                // перебираем двумерный массив и получаем индекс массива элементов
                var readingsInRow: [[TextAndReading]] = []
                for row in example.enumerated() {
                    var textAndReading: [TextAndReading] = []
                    for kanjiAndOkurigana in row.element.enumerated() {
                        let text = kanjiAndOkurigana.element
                        let reading = getReading(kajiWithReading:
                                                    separated[row.offset][kanjiAndOkurigana.offset],
                                                 kanjiAndOkurigana: text)
                        textAndReading.append(TextAndReading(text: text, reading: reading))
                    }
                    readingsInRow.append(textAndReading)
                }
                result[element.key] = readingsInRow
            }
        }
        return result
    }
    
    private func getReading(kajiWithReading: String, kanjiAndOkurigana: String) -> String {
        var result = ""
        var reading = kajiWithReading
        var kanjiAndOkurigana = kanjiAndOkurigana
        while kanjiAndOkurigana != "" {
            if kanjiAndOkurigana.count > 1 {
                reading.removeLast()
                kanjiAndOkurigana.removeLast()
            } else {
                reading.removeFirst()
                kanjiAndOkurigana.removeFirst()
            }
        }
        result = reading
        return result
    }
    
    private func getExampleKanjiWithType(allKanji: [KankenReplacer], currentKanji: KankenReplacer) -> [SchoolLevel: [[String]]] {
        var result: [SchoolLevel: [[String]]] = [:]
//        var forResultStringArray: [String] = []
        
        for element in currentKanji.examples {
            // разделяет строку на массив если там есть ・
            let separateRow = element.value.components(separatedBy: "・")
            
            // преобразует массив в двумерный убирая все кроме кандзи
            let twoDemArray = getTwodemensionArray(separateRow, allKanji)
            
            // возвращает массив истоящий из массивов кандзи с окуриганой и без для разделения на чтение и без
            let separated = separated(separatedRow: separateRow, twoDemArray: twoDemArray)
            
            result[element.key] = separated
        }
        return result
    }
    
    private func getTwodemensionArray(_ array: [String], _ allKanji: [KankenReplacer]) -> [[String]] {
        var result: [[String]] = []
        
        for separatedArrayElement in array {
            var array: [String] = []
            for character in separatedArrayElement {
                for kanji in allKanji where String(character) == kanji.body {
                    array.append(kanji.body)
                }
            }
            if !array.isEmpty {
                result.append(array)
            }
        }
        return result
    }
    
    private func separated(separatedRow: [String], twoDemArray: [[String]]) -> [[String]] {
        var result: [[String]] = []
        for (index, row) in separatedRow.enumerated() {
            var row = row
            var newArray: [String] = []
            for kanji in twoDemArray[index].reversed() {
                // делим строку по заданному кандзи с самого конца строки
                let parts = row.components(separatedBy: kanji)
                if parts.count > 1 {
                    newArray.append(kanji + parts[1])
                    row = parts[0]
                } else {
                    newArray.append(kanji)
                }
            }
            result.append(newArray.reversed())
        }
        return result
    }
}
