//
//  KankenExamplesRowView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/11/05.
//

import SwiftUI

struct KankenExamplesRowView: View {
    @EnvironmentObject var store: Store
    let currentKankenKanji: KanjiKankenModel
    
    var body: some View {
        ForEach(SchoolLevel.allCases, id: \.self) { level in
            if let row = currentKankenKanji.getExamplesWithReading(level) {
                VStack(spacing: Settings.paddingBetweenText) {
                    HStack {
                        Text(level.rawValue)
                            .font(.system(size: TextSizes.kanjiBody))
                        Spacer()
                    }
                        let tDA = createTDA(row)
                    VStack(alignment: .leading, spacing: Settings.paddingBetweenText) {
                        ForEach(tDA, id: \.self) { section in
                            HStack(spacing: TextSizes.spacingBetweenWords) {
                                ForEach(section, id: \.self) { row in
                                    if elementCount(row) < 5 {
                                        Button(action: {
                                            
                                        }, label: {
                                            WordWithFuriganaView(word: row, currentKanji: currentKankenKanji, readingIsHidden: false)
                                        })
                                        .foregroundStyle(.black)
                                    } else {
                                        WordWithFuriganaView(word: row, currentKanji: currentKankenKanji, readingIsHidden: false)
                                    }
                                    VStack {
                                        Text("")
                                            .font(.system(size: TextSizes.kanjiBody))
                                        if row != tDA.last?.last, row.last?.wasDivided != true {
                                            Circle()
                                                .frame(width: TextSizes.deviderCircle,
                                                       height: TextSizes.deviderCircle)
                                        }
//                                        Circle()
//                                            .frame(width: TextSizes.deviderCircle,
//                                                   height: TextSizes.deviderCircle)
//                                            .opacity(row == tDA.last?.last ? 0 : 0.65)
                                    }
                                }
                                Spacer()
                            }
                        }
                    }
                        
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    func createTDA(_ row: [[TextAndReading]]) -> [[[TextAndReading]]] {
        // метод возвращает кортеж в виде ширины и массива из которого состоит слово
        func getWordAndSize() -> [(width: CGFloat, word: [TextAndReading])] {
            var allElements: [(width: CGFloat, word: [TextAndReading])] = []
            for parts in row {
                var currentWordWidth: CGFloat = 0
                var currentWord: [TextAndReading] = []
                for part in parts {
                    // размер символа + размер кружка и отступы
                    currentWordWidth += part.width() + TextSizes.deviderCircle + TextSizes.spacingBetweenWords
                    currentWord.append(part)
                }
                allElements.append((currentWordWidth, currentWord))
            }
            return allElements
        }
        
        // метод возвращает двумерный массив, состоящий из массива компонентов слова
        // [ section: [row: [[TextAndReading]] ]
        func getArray() -> [[[TextAndReading]]] {
            guard let bound = UIScreen.current?.bounds.width else {
                print("Error in Recongnize Screen")
                return []
            }
            var result: [[[TextAndReading]]] = []
            let screenWidth = bound - Settings.padding * 2
            var avalWidth = screenWidth
            var currentRow: [[TextAndReading]] = []
            for element in getWordAndSize() {
                avalWidth -= element.width
                if avalWidth > 0 + TextSizes.deviderCircle * 2 {
                    currentRow.append(element.word)
                    // Данное условие вызвается если слово длиннее чем экран
                    // Определяется величина ширины выходящей за рамки,а с конца извлекаются элемены до того моменка как строка будет подходящей длинны
                } else if screenWidth < element.width {
//                    var extra = screenWidth - element.width
                    var extra = avalWidth - element.width
                    var parts = element.word
                    if extra + element.width < 0 {
                        result.append(currentRow)
                        currentRow = []
                        extra = screenWidth - element.width
                    }
                    var secondRow: [TextAndReading] = []
                    while extra < 0 {
                        let part = parts.removeLast()
                        secondRow.append(part)
                        extra += part.width()
                    }
                    var last = parts.removeLast()
                    last.devided()
                    parts.append(last)
                    currentRow.append(parts)
                    result.append(currentRow)
                    secondRow.reverse()
                    currentRow = []
                    currentRow.append(secondRow)
                    avalWidth = screenWidth - sumWidth(secondRow) - TextSizes.deviderCircle - TextSizes.spacingBetweenWords * 2
                } else {
                    result.append(currentRow)
                    avalWidth = screenWidth - element.width
                    currentRow = []
                    currentRow.append(element.word)
                }
            }
            result.append(currentRow)
            
            return result
        }
        
        func sumWidth(_ parts: [TextAndReading]) -> CGFloat {
            var width: CGFloat = 0
            for element in parts {
                width += element.width()
            }
            return width
        }
        
        let result = getArray()
        return result
    }
    
    func elementCount(_ word: [TextAndReading]) -> Int {
        var count = 0
        for part in word {
            count += part.text.count
        }
        return count
    }
}

#Preview {
    KankenExamplesRowView(currentKankenKanji: .ANOTHER_MOCK_KANKENKANJI)
        .environmentObject(Store())
}

#Preview {
    KankenExamplesRowView(currentKankenKanji: .MOCK_KANJIKANKEN)
        .environmentObject(Store())
}
