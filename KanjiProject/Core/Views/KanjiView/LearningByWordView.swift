//
//  LearningByWordView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/06/29.
//

import SwiftUI

struct LearningByWordView: View {
    @EnvironmentObject private var store: Store
    @EnvironmentObject private var globalChanging: GlobalChanging
    @Environment(\.dismiss) private var dismiss
    @State var currentKanji: KanjiKankenModel?
    @State private var hideReadings = true
//    @State private var currentWord: WordModel?
    @State private var showEdit = false
    let nouryokuLevel: NouryokuLevel
    let minute = 5
    
    var body: some View {
        VStack {
            HStack {
                CloseButton() {
                    globalChanging.exampleWord = nil
                }
                
                Spacer()
            }
            
            BorderedKanji(currentKanji: currentKanji)
            
            // MARK: Перевод кандзи
            if let meaning = currentKanji?.meaningInRussion {
                Text(meaning)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .opacity(hideReadings ? 0 : 0.5)
//                    .padding(.top, Settings.paddingBetweenText)
            }
            
            Divider()
            
            // MARK: Область слова и его перевод
            Group {
                if let word = globalChanging.exampleWord {
                    Divider()
                    
                    HStack {
                        WordWithFuriganaView(word: word, currentKanji: .empty, readingIsHidden: hideReadings, kanjiBody: TextSizes.learningWordBody, kanjiReading: TextSizes.learningWordReading)
                        
                        Spacer()
                        
                        ButtonsImages.chevronRight
                            .resizable()
                            .frame(width: ElementSize.dismissButtonShevronSize.width,
                                   height: ElementSize.dismissButtonShevronSize.height)
                            .opacity(hideReadings ? 0 : 0.5)
                    }
                    .padding(.bottom, -5)
                    
                    Divider()
                    
                    ForEach(getMeaning(word), id: \.self) { row in
                        Text(row)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .opacity(hideReadings ? 0 : 1)
                    }
                }
            }
            // MARK: Нажатие на область слова и его перевод
            .overlay {
                if !hideReadings {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            showEdit = true
                        }
                }
            }
            
            Group {
                
                if let currentKanji = currentKanji {
                    KanjiReadings(currentKanji: currentKanji, hideKanjiReadings: $hideReadings)
                }
                
//                if let meaning = currentKanji?.meaningInRussion {
//                    Text(meaning)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .opacity(hideReadings ? 0 : 1)
//                }
                
                Color.clear
            }
            .overlay {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        hideReadings.toggle()
                        if hideReadings {
                            saveAndreloadAction()
                            setCurrentWord()
                        }
                    }
            }
        }
        .padding(Settings.padding)
        .onAppear {
            setCurrentKanji()
            setCurrentWord()
//            currentKanji = .MOCK_KANJIKANKEN
        }
        .fullScreenCover(isPresented: $showEdit, content: {
            if let currentWord = globalChanging.exampleWord {
                EditWordView(word: currentWord)
//                SelectedWordDetailView()
//                    .environmentObject(globalChanging)
//                    .environmentObject(store)
            }
        })
    }
    
    private func setCurrentWord() {
        globalChanging.exampleWord = getWord()
    }
    
    // MARK: Получает слово, если оно имеется в группе, соответствующей уровню
    private func getWord() -> WordModel? {
        guard let currentKanji = currentKanji else { return nil }
        var componentsArray: [[TextAndReading]] = []
        
        for level in SchoolLevel.allCases where checkLevel().contains(level) {
            if let arr = currentKanji.getExamplesWithReading()[level] {
                componentsArray += arr
            }
        }
        var words: Set<WordModel> = []
        for components in componentsArray {
            if let word = store.findWordInBase(with: components) {
                words.insert(word)
            }
        }
        return words.randomElement()
    }
    
    private func checkLevel() -> [SchoolLevel] {
        var result: [SchoolLevel] = []
        switch nouryokuLevel {
        case .another:
            result.append(.外)
            fallthrough
        case .N1:
            result.append(.高)
            fallthrough
        case .N2:
            result.append(.中)
            fallthrough
        case .N3, .N4, .N5:
            result.append(.小)
        }
        return result
    }
    
    private func getMeaning(_ word: WordModel) -> [String] {
        let result = word.meaningInRussian.components(separatedBy: "・")
        return result
    }
    
    private func saveAndreloadAction() {
        currentKanji?.setCurrentDate()
        if let currentKanji = currentKanji {
            store.kanjiKankenStore.update(set: currentKanji)
        }
        setCurrentKanji()
    }
    
    private func setCurrentKanji() {
        currentKanji = getKanji()
        Task {
            print("\nОсталось изучить \(showAfter(minute).count) Кандзи")
        }
    }
    
    private func getKanji() -> KanjiKankenModel? {
        let result = Set(showAfter(minute)).randomElement()
        return result
    }
    
    private func findExpectedKanjiArray() -> [KanjiKankenModel] {
        var allCurrentLevelKanji = store.kanjiKankenStore.getAllKanji(below: nouryokuLevel)
        allCurrentLevelKanji = allCurrentLevelKanji
            .filter { !($0.lastAnswer() ?? false) }
            .filter { $0.inLearningList() }
        return allCurrentLevelKanji
    }
    
    func showAfter(_ min: Int) -> [KanjiKankenModel] {
        return findExpectedKanjiArray().filter { $0.showKanji(after: min) }
    }
}

#Preview {
    LearningByWordView(nouryokuLevel: .N5)
        .environmentObject(Store())
        .environmentObject(GlobalChanging())
}
