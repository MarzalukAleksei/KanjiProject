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
            if let row = currentKankenKanji.examplesWithReading[level] {
                VStack(/*alignment: .leading, */spacing: 0) {
                    HStack {
                        Text(level.rawValue)
                        Spacer()
                    }
                        let tDA = createTDA(row)
                    VStack(alignment: .leading, spacing: Settings.paddingBetweenText) {
                        ForEach(tDA, id: \.self) { section in
                            HStack(spacing: TextSizes.spacingBetweenWords) {
                                ForEach(section, id: \.self) { row in
                                    MarkKanjiInRow(word: row, currentKanji: currentKankenKanji, readingIsHidden: false)
                                    VStack {
                                        Text("")
                                            .font(.system(size: TextSizes.kanjiBody))
                                        Circle()
                                            .frame(width: TextSizes.deviderCircle,
                                                   height: TextSizes.deviderCircle)
                                            .opacity(row == tDA.last?.last ? 0 : 0.7)
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
                if avalWidth > 0 {
                    currentRow.append(element.word)
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
        let result = getArray()
        return result
    }
}

fileprivate struct MarkKanjiInRow: View {
    let word: [TextAndReading]
    let currentKanji: KanjiKankenModel
    let readingIsHidden: Bool
    var body: some View {
            HStack(spacing: 0) {
                ForEach(word, id: \.self) { part in
                VStack {
                    if part.text.contains(currentKanji.body) {
//                    if String(currentKanji.body.first!) == part.text {
                        Text(part.reading)
                            .font(.system(size: TextSizes.kanjiReading))
                            .foregroundStyle(.red)
                            .opacity(readingIsHidden ? 0 : 1)
                        Text(part.text.removeAll(after: "（"))
                            .font(.system(size: TextSizes.kanjiBody))
                            .foregroundStyle(.red)
                    } else {
                        Text(part.reading)
                            .font(.system(size: TextSizes.kanjiReading))
                            .opacity(readingIsHidden ? 0 : 1)
                        Text(part.text.removeAll(after: "（"))
                            .font(.system(size: TextSizes.kanjiBody))
                    }
                }
                .frame(width: part.width())
            }
        }
    }
}

#Preview {
    KankenExamplesRowView(currentKankenKanji: .MOCK_KANJIKENTEI)
        .environmentObject(Store())
}
