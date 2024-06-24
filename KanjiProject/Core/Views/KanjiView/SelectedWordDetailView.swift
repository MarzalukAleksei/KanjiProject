//
//  SelectedWordDetailView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/06/20.
//

import SwiftUI

struct SelectedWordDetailView: View {
    @EnvironmentObject private var store: Store
    @EnvironmentObject private var globalChanging: GlobalChanging
    @State private var kanjiSize: CGFloat = 0
    let screenSize = UIScreen.current?.bounds
    var body: some View {
        GeometryReader { geo in
                ZStack {
                    Color.clear.ignoresSafeArea()
                    ZStack {
                        GeometryReader { recSize in
                            RoundedRectangle(cornerRadius: 25)
                                .foregroundStyle(.white)
                            RoundedRectangle(cornerRadius: 25)
                                .strokeBorder(lineWidth: 1.5)
                                .shadow(radius: 10)
                            VStack(spacing: 1) {
//                                RectData(kanji: [.ANOTHER_MOCK_KANKENKANJI, .MOCK_KANJIKANKEN], size: recSize.size)
//                                ScrollView {
                                    RectData(kanji: getKanji(), word: globalChanging.exampleWord, store: store, size: recSize.size)
//                                }
                            }
                            .padding(Settings.padding)
                        }
                    }
                    .frame(width: geo.size.width - Settings.padding * 5,
                           height: geo.size.height - Settings.padding * 9)
                    .onTapGesture {
                        globalChanging.exampleWord = nil
                    }
                }
            }
        }
    
    func getKanji() -> [KanjiKankenModel] {
        var result: [KanjiKankenModel] = []
        guard let word = globalChanging.exampleWord else { return result }
        for element in word.body {
            if let kanji = store.kanjiKankenStore.getAll().first(where: { $0.body == String(element)}) {
                result.append(kanji)
            }
        }
        return result
    }
}

#Preview {
    SelectedWordDetailView()
        .environmentObject(Store())
        .environmentObject(GlobalChanging())
}

private struct RectData: View {
    let kanji: [KanjiKankenModel]
    let word: WordModel?
    let store: Store
    let size: CGSize
    var body: some View {
        ForEach(kanji) { kanji in
            HStack {
                Text(kanji.body)
                    .font(.system(size: setKanjiSize()))
                VStack(alignment: .leading) {
                    if let meaning = kanji.meaningInRussion {
                        Text(meaning)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, Settings.paddingBetweenText / 2)
                    }
                    
                    ForEach(SchoolLevel.allCases, id: \.self) { level in
                        if let reading = kanji.kunReading[level] {
                            HStack(alignment: .top) {
                                Text(level.rawValue)
                                Text(reading)
                            }
                        }
                    }
                    
                    ForEach(SchoolLevel.allCases, id: \.self) { level in
                        if let reading = kanji.onReading[level] {
                            HStack(alignment: .top) {
                                Text(level.rawValue)
                                Text(reading)
                            }
                        }
                    }
                }
                .font(.system(size: setReadingsSize()))
                
                Spacer()
                
                if let nouryokuLevel = kanji.nouryokuLevel, nouryokuLevel != .another {
                    Text("\(nouryokuLevel)")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
        }
        .padding(.bottom, Settings.paddingBetweenText)
        
        let ar = TextAndReading.setTRArray(getWord())
        WordWithFuriganaView(word: ar, currentKanji: .empty, readingIsHidden: false)
            .setFontSize(kanjiSize: 30, readingSize: 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(maxWidth: .infinity)
        
        let word = setWord()
        let translates = findTranslate(word).components(separatedBy: "・")
        ForEach(translates, id: \.self) { translate in
            Text(translate)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    func findTranslate(_ word: String) -> String {
        let words = Set(store.getAllWords())
        guard let translate = words.first(where: { $0.body == word }) else { return "Перевод не обнаружен" }
            return translate.meaningInRussian
    }
    
    func setKanjiSize() -> CGFloat {
        return size.width / 12
    }
    
    func setReadingsSize() -> CGFloat {
        return setKanjiSize() / 1.7
    }
    
    func setWord() -> String {
        if let word = word {
            return word.body
        }
        return ""
    }
    
    func getWord() -> WordModel {
        if let word = word {
            return word
        }
        return .empty
    }
}
