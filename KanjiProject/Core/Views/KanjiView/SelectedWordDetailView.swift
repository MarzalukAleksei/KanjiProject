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
    let storeOperations: StoreOperations

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.clear
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture {
                        globalChanging.wordToChange = nil
                    }
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundStyle(.white)
                    RoundedRectangle(cornerRadius: 25)
                        .strokeBorder(lineWidth: 1.5)
                        .shadow(radius: 10)
                    VStack {
                        ScrollView {
                            RectData(kanji: storeOperations.getKanjiArray(from: globalChanging.wordToChange), word: $globalChanging.wordToChange, store: store, size: geo.size.width - 80)
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
                    globalChanging.wordToChange = nil
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
        if let word = globalChanging.wordToChange {
            return word
        }
        return .empty
    }
    
//    private func getKanji() -> [KanjiKankenModel] {
//        var result: [KanjiKankenModel] = []
//        guard let word = globalChanging.wordToChange else { return result }
//        for element in word.body {
//            if let kanji = store.kanjiKankenStore.getAll().first(where: { $0.body == String(element)}) {
//                result.append(kanji)
//            }
//        }
//        return result
//    }
}

#Preview {
    SelectedWordDetailView(storeOperations: StoreOperations(store: Store(), userSettings: UserSettings()))
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
                .setFontSize(kanjiSize: ElementSize.kanjiSize(size), readingSize: ElementSize.furiganaSize(size))
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(maxWidth: .infinity)
            let word = setWord()
            
            let translates = findTranslate(word).components(separatedBy: "・")
            ForEach(translates, id: \.self) { translate in
                Text(translate)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: ElementSize.furiganaSize(size)))
            }
            .padding(.horizontal, Settings.padding)
            
            Divider()
                .padding(.vertical, Settings.paddingBetweenText)
            
            ListOfKanjiInGivenWordView(kanji: kanji, size: size)
            .padding(.bottom, Settings.paddingBetweenText)
        }
        .padding(.top, Settings.padding)
    }
    
    private func findTranslate(_ word: String) -> String {
        let words = Set(store.getAllWords())
        let translate = words.first { main in
            if main.body == word, !main.meaningInRussian.isEmpty {
                return true
            }
            return false
        }
//        guard let translate = translate else { return "Перевод не обнаружен" }
        guard let translate = translate else { return "" }
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
