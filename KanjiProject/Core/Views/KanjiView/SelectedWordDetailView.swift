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
    @State private var editButtonPressed = false
    @State private var printState = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.clear
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture {
                        globalChanging.exampleWord = nil
                    }
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundStyle(.white)
                    RoundedRectangle(cornerRadius: 25)
                        .strokeBorder(lineWidth: 1.5)
                        .shadow(radius: 10)
                    VStack {
                        ScrollView {
                            RectData(kanji: getKanji(), word: $globalChanging.exampleWord, store: store, size: geo.size.width - 80)
                        }
                        .padding(Settings.padding)
                        
                        Button(action: {
                            editButtonPressed = true
                        }, label: {
                            Text("Исправить")
                                .frame(maxWidth: .infinity)
                                .font(.title)
                                .background(Color.gray)
                                .foregroundStyle(.white)
                                .clipShape(PartialRoundedRectangle(cornerRadius: 24, corners: [.bottomLeft, .bottomRight]))
                        })
                        .padding(.bottom, 1.5)
                        .padding(.horizontal, 1.5)
//                        .padding(.leading, 0.4)
                    }
                }
                .padding(.horizontal, Settings.padding * 2.5)
                .padding(.vertical, Settings.padding * 5)
                .onTapGesture {
                    globalChanging.exampleWord = nil
                }
                
            }
            .fullScreenCover(isPresented: $editButtonPressed, content: {
                EditWordView(word: getWord())
                    .environmentObject(globalChanging)
                    .environmentObject(store)
            })
        }
    }
    
    private func getWord() -> WordModel {
        if let word = globalChanging.exampleWord {
            return word
        }
        return .empty
    }
    
    private func getKanji() -> [KanjiKankenModel] {
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
    @Binding var word: WordModel?
    let store: Store
    let size: CGFloat
    var body: some View {
        VStack(spacing: 0) {
            let ar = TextAndReading.setTRArray(getWord())
            WordWithFuriganaView(word: ar, currentKanji: .empty, readingIsHidden: false)
                .setFontSize(kanjiSize: kanjiSize(), readingSize: furiganaSize())
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(maxWidth: .infinity)
            let word = setWord()
            
            let translates = findTranslate(word).components(separatedBy: "・")
            ForEach(translates, id: \.self) { translate in
                Text(translate)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: furiganaSize()))
            }
            .padding(.horizontal, Settings.padding)
            
            Divider()
                .padding(.vertical, Settings.paddingBetweenText)
            
            ListOfKanjiInGivenWordView(kanji: kanji, size: size)
            .padding(.bottom, Settings.paddingBetweenText)
        }
        .padding(.top, Settings.padding)
    }
    
    private func kanjiSize() -> CGFloat {
        size / 15 / 1.5
    }
    
    private func furiganaSize() -> CGFloat {
        kanjiSize() / 1.7
    }
    
    private func findTranslate(_ word: String) -> String {
        let words = Set(store.getAllWords())
        guard let translate = words.first(where: { $0.body == word }) else { return "Перевод не обнаружен" }
        return translate.meaningInRussian
    }
    
    private func setWord() -> String {
        if let word = word {
            return word.body
        }
        return ""
    }
    
    private func getWord() -> WordModel {
        if let word = word {
            return word
        }
        return .empty
    }
}
