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
    @State private var currentWord: WordModel?
    @State private var words: [WordModel] = []
    @State private var showAllert = false
    @State private var hideReading = false
    @State private var showEditView = false
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    CloseButton()
                    
                    Spacer()
                    
                    Text(!words.isEmpty ? "Осталось \(words.count) слов" : "Последнее слово")
                    
                    Spacer()
                    
                    Button {
                        global.exampleWord = currentWord
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
                        if let currentWord {
                            HStack {
                                Spacer()
                                WordWithFuriganaView(word: currentWord.getTextAndReading(),
                                                     readingIsHidden: hideReading,
                                                     kanjiBody: ElementSize.kanjiSize(geo.size.width, 1),
                                                     kanjiReading: ElementSize.furiganaSize(geo.size.width, 1))
                                Spacer()
                            }
                            let translates = currentWord.getSeparatedMeaning()
                                ForEach(translates, id: \.self) { row in
                                    Text(row)
                                        .frame(maxWidth: .infinity)
                                        .font(.title)
                                }
                            let kanjiList = StoreOperations(store: store, chosenLevel: currentLevel).getKanjiArray(from: currentWord)
                            ListOfKanjiInGivenWordView(kanji: kanjiList, size: geo.size.width)
                                .padding(.bottom, Settings.paddingBetweenText)
                        }
                    }
                }
                Spacer()
            }
            .padding(Settings.padding)
            GeometryReader { _ in
                VStack {
                    Text(currentWord?.body ?? "Check word")
                    Text(currentWord?.reading ?? "Check reading")
                }
            }
            
            Spacer()
            
            Button {
                getWord()
            } label: {
                Text("Следующее слово")
                    .modifier(Modifiers.learningNextButton)
            }
            
        }
        .navigationBarHidden(true)
        .onAppear {
            tabBarState.tabBarIsHidden = true
            loadWords()
            getWord()
        }
        //        .alert("Empty array", isPresented: $showAllert) {
        //            Button("Close", role: .cancel) {
        //                dismiss()
        //            }
        //        }
        .fullScreenCover(isPresented: $showEditView, content: {
            if let currentWord {
                EditWordView(word: currentWord)
                    .environmentObject(global)
                    .environmentObject(store)
            }
        })
    }

    func loadWords() {
        words = StoreOperations(store: store, chosenLevel: currentLevel).learningWords(for: currentLevel)
    }
    
    func getWord() {
        do {
            currentWord = try StoreOperations(store: store, chosenLevel: currentLevel).getWord(from: words)
            words.removeAll(where: { $0.id == currentWord?.id })
        } catch {
            showAllert = true
        }
    }
}

#Preview {
    LearnWordView()
        .environmentObject(Store.MOCK_STORE)
        .environmentObject(TabBarState())
    
}
