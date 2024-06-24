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
    var kanjiBody = TextSizes.kanjiBody
    var kanjiReading = TextSizes.kanjiReading
    var body: some View {
            HStack(spacing: 0) {
                ForEach(word, id: \.self) { part in
                VStack {
                    if part.text.contains(currentKanji.body) {
                        HStack {
                            Text(part.reading)
                                .font(.system(size: kanjiReading))
                                .foregroundStyle(.red)
                                .opacity(readingIsHidden ? 0 : 1)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, part.reading.count == 1 ? kanjiReading / 2.5 : 0)
                        }
                        let text = sep(part)
                        HStack(spacing: 0) {
                            ForEach(text, id: \.self) { char in
                                if char == currentKanji.body {
                                    Text(char)
                                        .foregroundStyle(ElementsColors.currentKanjiInExample)
                                } else {
                                    Text(char)
                                }
                            }
                        }
                        .font(.system(size: kanjiBody))
                    } else {
                        Text(part.reading)
                            .font(.system(size: kanjiReading))
                            .opacity(readingIsHidden ? 0 : 1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, part.reading.count == 1 ? kanjiReading / 2.5 : 0)
                        Text(part.text.removeAll(after: "（"))
                            .font(.system(size: kanjiBody))
                    }
                }
                .frame(width: part.width(kanjiReading: kanjiReading, kanjiBody: kanjiBody))
            }
        }
    }
    
    func setFontSize(kanjiSize: CGFloat, readingSize: CGFloat) -> some View {
        var view = WordWithFuriganaView(word: word, currentKanji: currentKanji, readingIsHidden: readingIsHidden)
        view.kanjiBody = kanjiSize
        view.kanjiReading = readingSize
        return view
    }
    
    private func sep(_ part: TextAndReading) -> [String] {
        var result: [String] = []
        var array = part.text.removeAll(after: "（").map { String($0) }
        result.append(array.removeFirst())
        result.append(array.joined())
        
        return result
    }
}

#Preview {
    WordWithFuriganaView(word: [TextAndReading(text: "漢", reading: "かん"), TextAndReading(text: "字", reading: "じ")], currentKanji: .init(id: 0, body: "字", defaultReading: "", kunReading: [:], onReading: [:], examples: [:], examplesWithReading: [:], meaning: "", keys: "", kankenLevel: .none, stroke: 0, link: ""), readingIsHidden: false)
        .setFontSize(kanjiSize: 40, readingSize: 30)
}
