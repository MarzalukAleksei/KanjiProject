//
//  kanjiKenteiRowWithReadingView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/10/21.
//

import SwiftUI

private struct FuriganaAndKanji: View {
    let kanji: [TextAndReading]
    let kanjiKentei: KanjiKankenModel
    var body: some View {
        HStack(spacing: 0) {
            ForEach(kanji, id: \.self) { word in
                VStack(alignment: .center, spacing: -3) {
                    if word.text.contains(kanjiKentei.body) {
                        Text(word.reading)
                            .foregroundStyle(Color.red)
                            .font(.footnote)
                        Text(word.text)
                            .foregroundStyle(Color.red)
                    } else {
                        Text(word.reading)
                            .font(.footnote)
                        Text(word.text)
                    }
                }
            }
        }
    }
}

struct kanjiKenteiRowWithReadingView: View {
    @EnvironmentObject var store: Store
    let kanjiKentei: KanjiKankenModel
    
    var body: some View {
        let array = getRowWithReadingAndText()
        VStack(/*alignment: .leading*/) {
            ForEach(ExampleType.allCases, id: \.self) { type in
                let row = array[type]
                if let row = row {
//                    if !row.isEmpty {
//                        Text(type.rawValue)
//                    }
                    ForEach(row, id: \.self) { words in
                        
                        HStack {
                            FuriganaAndKanji(kanji: words, kanjiKentei: kanjiKentei)
                            // Перевод
                            Text(" - ")
                            Text(findTranslate(words))
                            Spacer()
                        }
                        .padding(.leading, Settings.padding)
                    }
                }
            }
        }
        
    }
    
    // Поиск в словаре перевода
    private func findTranslate(_ word: [TextAndReading]) -> String {
        var result = ""
        var wordAndReading: (word: String, reading: String) = ("", "")
        for part in word {
            wordAndReading.word += part.text
            wordAndReading.reading += part.reading
        }
        let wordsFromDictionary = store.dictionaryStore.getAll().filter { $0.body.contains(wordAndReading.word)}
        
        guard let wordFromDictionary = wordsFromDictionary.first(where: { $0.body == wordAndReading.word}) else { return "" }
        result = DictionaryModel.getFirstExample(word: wordFromDictionary)
        return result
    }
    
    // получение основной строки для отображения
    private func getRowWithReadingAndText() -> [ExampleType: [[TextAndReading]]] {
        var result: [ExampleType: [[TextAndReading]]] = [:]
        let exampleWithType = getExampleKanjiWithType()
        
        for element in kanjiKentei.examplesWithReading {
            // разделяет строку на массив если там есть ・
            let separateRow = element.value.components(separatedBy: "・")
            // преобразует массив в двумерный убирая все кроме кандзи
            let twoDemArray = getTwodemensionArray(separateRow)
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
    // получение чтения для кандзи
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
    
    // получение базовой комбинации Kanji+okurigana для дальнейшего поиска чтения
    private func getExampleKanjiWithType() -> [ExampleType: [[String]]] {
        var result: [ExampleType: [[String]]] = [:]
//        var forResultStringArray: [String] = []
        
        for element in kanjiKentei.examples {
            // разделяет строку на массив если там есть ・
            let separateRow = element.value.components(separatedBy: "・")
            
            // преобразует массив в двумерный убирая все кроме кандзи
            let twoDemArray = getTwodemensionArray(separateRow)
            
            // возвращает массив истоящий из массивов кандзи с окуриганой и без для разделения на чтение и без
            let separated = separated(separatedRow: separateRow, twoDemArray: twoDemArray)
            
            result[element.key] = separated
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
    
    private func getTwodemensionArray(_ array: [String]) -> [[String]] {
        var result: [[String]] = []
        
        for separatedArrayElement in array {
            var array: [String] = []
            for character in separatedArrayElement {
                for kanji in store.kanjiKanken.getAll() where String(character) == kanji.body {
                    array.append(kanji.body)
                }
            }
            if !array.isEmpty {
                result.append(array)
            }
        }
        return result
    }
}

#Preview {
    kanjiKenteiRowWithReadingView(kanjiKentei: .MOCK_KANJIKENTEI)
        .environmentObject(Store())
}
