//
//  LearnWordView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/11/04.
//

import SwiftUI

struct CheckWordsView: View { // ВРЕМЕННЫЙ ВЬЮ. УБРАТЬ ПОСЛЕ ПРОВЕРКИ СЛОВ В БАЗЕ
    @Environment(\.dismiss) private var dismiss
    @AppStorage("baseWordLevel") private var currentLevel: NouryokuLevel = .N5
    @EnvironmentObject private var store: Store
    @EnvironmentObject private var tabBarState: TabBarState
    @EnvironmentObject private var global: GlobalChanging
    @EnvironmentObject private var userSettings: UserSettings
    @EnvironmentObject private var coordinator: Coordinator
    @State private var words: [WordModel] = []
    @State private var showAllert = false
    @State private var hideReading = false
    @State private var showEditView = false
    @State var lastWord: WordModel?
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
                    
                    Text(global.wordToChange?.body ?? "")
                    
                    Spacer()
                    
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
                    ScrollViewReader { proxy in
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
                                .id(0)
                                let translates = currentWord.getSeparatedMeaning()
                                
                                ForEach(translates, id: \.self) { row in
                                    Text(row)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.title)
                                }
                                
                                Divider()
                                    .padding(.vertical, Settings.paddingBetweenText)
                                
                                Text(currentWord.reading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.title)
                                
                                Divider()
                                
                                Text(currentWord.levelInTag.reduce(into: "", { partialResult, level in
                                    let level = "\(level)"
                                    partialResult = partialResult.isEmpty ? level : partialResult + ", \(level)"
                                }))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Divider()
                                    .padding(.vertical, Settings.paddingBetweenText)
                                
                                let kanjiList = storeOperations.getKanjiArray(from: global.wordToChange)
                                ListOfKanjiInGivenWordView(kanji: kanjiList, action: { selectedKanji in
                                    print(selectedKanji.body)
                                })
                                    .padding(.bottom, Settings.paddingBetweenText)
                            }
                        }
                        .onChange(of: global.wordToChange) { _ in
                            scrollTo(proxy: proxy)
                        }
                    }
                }
                Spacer()
            }
            .padding(Settings.padding)
            
            Spacer()
            
            Button {
                global.wordToChange = lastWord
            } label: {
                Text("Вернуться к последнему слову")
                    .modifier(Modifiers.rightAnswerButton)
                    .background(.purple.opacity(0.4))
            }
            
            Button {
                checkWordLaterAction()
                lastWord = global.wordToChange
                getWord()
            } label: {
                Text("Пропустить и показать следующее слово")
                    .modifier(Modifiers.rightAnswerButton)
            }
            
            Button {
                wordCheckedAction()
                lastWord = global.wordToChange
                getWord()
            } label: {
                Text("Это слово готово")
                    .modifier(Modifiers.rightAnswerButton)
                    .background(.blue)
            }
            .padding(.top, 30)
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
    
    func checkWordLaterAction() {
        guard var currentWord = global.wordToChange else { return }
        currentWord.checkItLater()
        store.baseWordsStore.update(set: currentWord)
        store.baseWordsStore.saveInFileManager()
    }
    
    func wordCheckedAction() {
        guard var currentWord = global.wordToChange else { return }
        currentWord.wordWasChecked()
        store.baseWordsStore.update(set: currentWord)
        store.baseWordsStore.saveInFileManager()
    }

    func loadWords() {
        words = storeOperations.words(for: currentLevel).filter {
            $0.thisWordWasChecked == nil
        }
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
    
    func scrollTo(proxy: ScrollViewProxy) {
        proxy.scrollTo(0, anchor: .center)
    }
}

#Preview {
    CheckWordsView()
        .environmentObject(Store.MOCK_STORE)
        .environmentObject(TabBarState())
        .environmentObject(UserSettings())
        .environmentObject(Coordinator())
}
