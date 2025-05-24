//
//  LearnWordView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/11/04.
//

import SwiftUI

struct LearnWordView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("baseWordLevel") private var currentLevel: NouryokuLevel = .N5
    @EnvironmentObject private var store: Store
    @EnvironmentObject private var tabBarState: TabBarState
    @EnvironmentObject private var global: GlobalChanging
    @EnvironmentObject private var coordinator: Coordinator
    @EnvironmentObject private var userSettings: UserSettings
    @State private var words: [WordModel] = []
    @State private var showAllert = false
    @State private var hideReading = false
    @State private var showEditView = false
    var storeOperations: StoreOperations {
        .init(store: store, userSettings: userSettings)
    }
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    CloseButton()
                    
                    Spacer()
                    
                    Text(!words.isEmpty ? "Осталось \(words.count) слов" : "Последнее слово")
                    
                    Spacer()
                    
                    Button {
                        saveButton()
                    } label: {
                        Text("Сохранить")
                            .frame(height: ElementSize.closeButton.height)
                    }
                    .opacity(global.wordWasChanged() ? 1 : 0)

                    Button {
                        showEditView = true
                    } label: {
                        ButtonsImages.pencil
                            .resizable()
                            .foregroundStyle(ElementsColors.editWordButton)
                            .modifier(Modifiers.editWordButton)
                    }

                }
                GeometryReader { geo in
                    ScrollView {
                        if let currentWord = global.wordToChange {
                            HStack {
                                Spacer()
                                WordWithFuriganaView(word: currentWord.getTextAndReading() ,
                                                     readingIsHidden: hideReading,
                                                     kanjiBody: TextSizes.kanjiSize(geo.size.width, 1),
                                                     kanjiReading: TextSizes.furiganaSize(geo.size.width, 1))
                                
                                Spacer()
                            }
                            let translates = currentWord.getSeparatedMeaning()
                            
                            ForEach(translates, id: \.self) { row in
                                Text(row)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.title)
                            }
                            
                            Divider()
                                .padding(.vertical, Settings.paddingBetweenText)
                            
                            let kanjiList = storeOperations.getKanjiArray(from: global.wordToChange)
                            ListOfKanjiInGivenWordView(kanji: kanjiList, action: { selectedKanji in
                                print(selectedKanji.body)
                                coordinator.push(page: .test(num: 1))
                            })
                                .padding(.bottom, Settings.paddingBetweenText)
                        }
                    }
                }
                Spacer()
            }
            .padding(Settings.padding)
            
            Spacer()
            
            Button {
//                getWord()
                updStore()
                nextWord()
            } label: {
                Text("Следующее слово")
                    .modifier(Modifiers.rightAnswerButton)
            }
            
        }
        .navigationBarHidden(true)
        .onAppear {
            tabBarState.tabBarIsHidden = true
            loadWords()
            getWord()
        }
        .fullScreenCover(isPresented: $showEditView, content: {
            EditWordView(word: global.wordToChange ?? .empty)
                    .environmentObject(global)
                    .environmentObject(store)
        })
    }
    
    func saveButton() {
        Task {
            guard let word = global.wordToChange else { return }
            global.wordToChange = nil
            global.wordToChange = word
            await storeOperations.updWord(word)
            storeOperations.updBaseWordFile()
            storeOperations.updUserWordsFile()
        }
    }

    func loadWords() {
        words = storeOperations.learningWords()
    }
    
    func getWord() {
        if let word = global.wordToChange {
            words.removeAll(where: { $0.id == word.id })
        } else {
            nextWord()
        }
    }
    
    func nextWord() {
        do {
            global.wordToChange = try storeOperations.getWord(from: words)
            let word = global.wordToChange
            words.removeAll(where: { $0.id == word?.id })
        } catch {
            showAllert = true
        }
    }
    
    func updStore() {
        Task {
            guard var currentWord = global.wordToChange else { return }
            currentWord.dateStamp = .init()
            await storeOperations.updWord(currentWord)
            storeOperations.updBaseWordFile()
            storeOperations.updUserWordsFile()
        }
    }
}

#Preview {
    LearnWordView()
        .environmentObject(Store.MOCK_STORE)
        .environmentObject(TabBarState())
        .environmentObject(Coordinator())
        .environmentObject(UserSettings())
}
