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
    let databaseOperation: DatabaseOperations
    @State var availableKanji: [KanjiKankenModel] = []
    
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
                            saveAndReloadAction()
                            setCurrentWord()
                        }
                    }
            }
        }
        .padding(Settings.padding)
        .task {
            await availableKanji = databaseOperation.getAllSuitableKanji()
            setCurrentKanji()
            setCurrentWord()
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
        databaseOperation.loadWord(for: currentKanji)
    }
    
    private func getMeaning(_ word: WordModel) -> [String] {
        word.getSeparatedMeaning()
    }
    
    private func saveAndReloadAction() {
        currentKanji?.setCurrentDate()
        if let currentKanji = currentKanji {
            store.kanjiKankenStore.update(set: currentKanji)
        }
        setCurrentKanji()
    }
    
    func setCurrentKanji() {
        currentKanji = getKanji()
        availableKanji.removeAll(where: { $0.id == currentKanji?.id })
        
        if currentKanji != nil {
            print("\nОсталось изучить \(availableKanji.count + 1) Кандзи")
        } else {
            print("Все изучено")
        }
    }
    
    private func getKanji() -> KanjiKankenModel? {
        let result = Set(availableKanji).randomElement()
        return result
    }
}

#Preview {
    LearningByWordView(nouryokuLevel: .N5, databaseOperation: .init(store: Store(), chosenLevel: .N5))
        .environmentObject(Store())
        .environmentObject(GlobalChanging())
}
