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
    @State private var words: [WordModel] = []
    @State private var showAllert = false
    @State private var hideReading = false
    @State private var showEditView = false
    let storeOperations: StoreOperations
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    CloseButton()
                    
                    Spacer()
                    
                    Text(!words.isEmpty ? "Осталось \(words.count) слов" : "Последнее слово")
                    
                    Spacer()
                    
                    Button {
//                        global.wordToChange = currentWord
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
                            ListOfKanjiInGivenWordView(kanji: kanjiList, size: geo.size.width)
                                .padding(.bottom, Settings.paddingBetweenText)
                        }
                    }
                }
                Spacer()
            }
            .padding(Settings.padding)
            
            Spacer()
            
            Button {
                getWord()
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
        .onDisappear {
            global.wordToChange = nil
        }
        .fullScreenCover(isPresented: $showEditView, content: {
            EditWordView(word: global.wordToChange ?? .empty)
                    .environmentObject(global)
                    .environmentObject(store)
        })
    }

    func loadWords() {
        words = storeOperations.learningWords(for: currentLevel)
    }
    
    func getWord() {
        do {
            global.wordToChange = try storeOperations.getWord(from: words)
            let currentWord = global.wordToChange
            words.removeAll(where: { $0.id == currentWord?.id })
        } catch {
            showAllert = true
        }
    }
}

#Preview {
    LearnWordView(storeOperations: StoreOperations(store: Store(),
                                                   userSettings: UserSettings()))
        .environmentObject(Store.MOCK_STORE)
        .environmentObject(TabBarState())
    
}
