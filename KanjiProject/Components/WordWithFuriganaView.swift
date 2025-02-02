//
//  WordWithFuriganaView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/02/06.
//

import SwiftUI

struct WordWithFuriganaView: View {
    private var word: [TextAndReading]
    private let currentKanji: KanjiKankenModel
    private let readingIsHidden: Bool
    private var kanjiBody: CGFloat
    private var kanjiReading: CGFloat
    
    /// Setup currentWord = .empty
    init(word: [TextAndReading],
         readingIsHidden: Bool,
         kanjiBody: CGFloat = TextSizes.kanjiBody,
         kanjiReading: CGFloat = TextSizes.kanjiReading)
    {
        self.word = word
        self.currentKanji = .empty
        self.readingIsHidden = readingIsHidden
        self.kanjiBody = kanjiBody
        self.kanjiReading = kanjiReading
    }
    
    init(word: [TextAndReading],
         currentKanji: KanjiKankenModel,
         readingIsHidden: Bool,
         kanjiBody: CGFloat = TextSizes.kanjiBody,
         kanjiReading: CGFloat = TextSizes.kanjiReading)
    {
        self.word = word
        self.currentKanji = currentKanji
        self.readingIsHidden = readingIsHidden
        self.kanjiBody = kanjiBody
        self.kanjiReading = kanjiReading
    }
    
    init(word: WordModel,
         currentKanji: KanjiKankenModel,
         readingIsHidden: Bool,
         kanjiBody: CGFloat = TextSizes.kanjiBody,
         kanjiReading: CGFloat = TextSizes.kanjiReading)
    {
        self.word = []
        self.currentKanji = currentKanji
        self.readingIsHidden = readingIsHidden
        self.kanjiBody = kanjiBody
        self.kanjiReading = kanjiReading
        
        self.word = transformWordModel(word)
    }
    
    var body: some View {
            HStack(spacing: 0) {
                ForEach(word, id: \.self) { part in
                    VStack(spacing: 0) {
                    if part.text.contains(currentKanji.body) {
                        HStack(alignment: .bottom) {
                            if part.reading != "" {
                                Text(part.reading)
                                    .font(.system(size: kanjiReading))
                                    .foregroundStyle(.red)
                                    .opacity(readingIsHidden ? 0 : 1)
                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                    .padding(.leading, part.reading.count == 1 ? kanjiReading / 2.5 : 0)
                                    .padding(.leading, furiganaPadding(part))
                            } else {
                                Color.clear
                                    .frame(height: kanjiReading)
                            }
                        }
                        let text = sep(part)
                        HStack(spacing: 0) {
                            ForEach(text, id: \.self) { char in
                                if char == currentKanji.body {
                                    Text(char)
                                        .foregroundStyle(ElementsColors.currentKanjiInExample)
                                        .frame(maxHeight: .infinity, alignment: .bottom)
                                } else {
                                    Text(char)
                                }
                            }
                        }
                        .font(.system(size: kanjiBody))
                    } else {
                        if part.reading != "" {
                            Text(part.reading)
                                .font(.system(size: kanjiReading))
                                .opacity(readingIsHidden ? 0 : 1)
                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .padding(.leading, part.reading.count == 1 ? kanjiReading / 2.5 : 0)
                                .padding(.leading, furiganaPadding(part))
                        } else {
                            Color.clear
                                .frame(height: kanjiReading)
                        }
                        Text(part.text.removeAll(after: "（"))
                            .font(.system(size: kanjiBody))
                    }
                }
                .frame(width: part.width(kanjiReading: kanjiReading, kanjiBody: kanjiBody))
            }
        }
    }
    
    // MARK: Поправить отступы
    private func furiganaPadding(_ part: TextAndReading) -> CGFloat {
        let partReadingCount = Double(part.reading.count)
        let roundedPropotions = 1 / ElementSize.furiganaPropotions
        if partReadingCount < roundedPropotions {
            let result = kanjiBody - (kanjiReading * roundedPropotions.rounded(.down))
            return result / partReadingCount.rounded(.up) - partReadingCount.rounded(.down)
        }
        return 0
    }
    
    func setFontSize(kanjiSize: CGFloat, readingSize: CGFloat) -> some View {
        var view = WordWithFuriganaView(word: word, currentKanji: currentKanji, readingIsHidden: readingIsHidden)
        view.kanjiBody = kanjiSize
        view.kanjiReading = readingSize
        return view
    }
    
    private func transformWordModel(_ word: WordModel) -> [TextAndReading] {
        var word = word
        word.reading = word.reading.replacingOccurrences(of: "[", with: "(")
        word.reading = word.reading.replacingOccurrences(of: "]", with: ")")
        var result: [TextAndReading] = []
        let array = word.reading.components(separatedBy: ")")
        for element in array where element != "" {
            let parts = element.components(separatedBy: "(")
            if parts.count > 1 {
                result.append(.init(text: parts[0], reading: parts[1]))
            } else {
                result.append(.init(text: parts[0], reading: ""))
            }
        }
        return result
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
        .frame(height: 60)
}
