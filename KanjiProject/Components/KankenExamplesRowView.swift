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
                VStack(spacing: 0) {
                    HStack {
                        Text(level.rawValue)
                        Spacer()
                    }
                        let tDA = createTDA(row)
                    VStack {
                        HStack {
                            ForEach(tDA, id: \.self) { section in
                                ForEach(section, id: \.self) { word in
                                    VStack {
                                        
                                            
                                    }
                                }
                            }
                        }
                    }
                        
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    func createTDA(_ row: [[TextAndReading]]) -> [[Int]] {
        guard let bound = UIScreen.current?.bounds.width else { return [] }
        let screenWidth = bound - Settings.padding * 2
        var avalWidth = screenWidth
        var result: [[Int]] = []
        var allElementsWidth: [CGFloat] = []
        for part in row {
            var currentWordWidth: CGFloat = 0
            for kanji in part {
                currentWordWidth += findWidth(kanji)
            }
            allElementsWidth.append(currentWordWidth)
        }
        
        var words: [Int] = []
        for element in allElementsWidth.enumerated() {
            avalWidth -= element.element
            if avalWidth >= 0 {
                words.append(element.offset)
//                result[section].append(element.offset)
            } else {
                avalWidth = screenWidth - element.element
                result.append(words)
                words = [element.offset]
            }
            result.append(words)
        }
        
        return result
    }
    
    private func findWidth(_ kanji: TextAndReading) -> CGFloat {
        let readingWidth = CGFloat(kanji.reading.count) * TextSizes.kanjiReading
        let kanjiBodyWidth = CGFloat(kanji.text.removeBrackets().count) * TextSizes.kanjiBody
        return readingWidth > kanjiBodyWidth ? readingWidth : kanjiBodyWidth
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
                    if currentKanji.body == part.text {
                        Text(part.reading)
                            .font(.system(size: TextSizes.kanjiReading))
                            .foregroundStyle(.red)
                            .opacity(readingIsHidden ? 0 : 1)
                        Text(part.text)
                            .font(.system(size: TextSizes.kanjiBody))
                            .foregroundStyle(.red)
                    } else {
                        Text(part.reading)
                            .font(.system(size: TextSizes.kanjiReading))
                            .opacity(readingIsHidden ? 0 : 1)
                        Text(part.text.removeBrackets())
                            .font(.system(size: TextSizes.kanjiBody))
                    }
                }
                .frame(width: findWidth(part))
            }
        }
    }
    
    private func findWidth(_ part: TextAndReading) -> CGFloat {
        let readingWidth = CGFloat(part.reading.count) * TextSizes.kanjiReading
        let kanjiBodyWidth = CGFloat(part.text.removeBrackets().count) * TextSizes.kanjiBody
        return readingWidth > kanjiBodyWidth ? readingWidth : kanjiBodyWidth
    }
}

#Preview {
    KankenExamplesRowView(currentKankenKanji: .MOCK_KANJIKENTEI)
        .environmentObject(Store())
}
