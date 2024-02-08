//
//  WordWithFuriganaView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/02/06.
//

import SwiftUI

struct WordWithFuriganaView: View {
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
//                        let text = part.text.removeAll(after: "（").map { String($0) }
                        let text = sep(part)
                        HStack(spacing: 0) {
                            ForEach(text, id: \.self) { char in
                                if char == currentKanji.body {
                                    Text(char)
                                        .foregroundStyle(.red)
                                } else {
                                    Text(char)
                                }
                            }
                        }
                        .font(.system(size: TextSizes.kanjiBody))
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
    
    func sep(_ part: TextAndReading) -> [String] {
        var result: [String] = []
        var array = part.text.removeAll(after: "（").map { String($0) }
        result.append(array.removeFirst())
        result.append(array.joined())
        
        return result
    }
}

#Preview {
    WordWithFuriganaView(word: [], currentKanji: .ANOTHER_MOCK_KANKENKANJI, readingIsHidden: false)
}
