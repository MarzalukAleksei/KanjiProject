//
//  SearchWordView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/02/26.
//

import SwiftUI

struct SearchWordView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var tabbarState: TabBarState
    @State var searchWord = ""
    @ObservedObject var autoCompleteWord = AutoCompleteWord(words: [])
    
    var body: some View {
        VStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                HStack {
                    TextField("Какое слово ищем?", text: $searchWord)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: searchWord, perform: { value in
                            autoCompleteWord.words = store.baseWordsStore.getAll()
                            autoCompleteWord.autoComplete(value)
                        })
                
                    NavigationLink(destination: CreateWordView(word: .init(body: searchWord))) {
                        ButtonsImages.pencil
                            .foregroundStyle(.white)
                    }
                }
                .padding(Settings.padding)
            }
            .frame(height: 40)
            
            List(autoCompleteWord.words) { word in
                NavigationLink {
//                    WordLearningView(level: .another, currentWord: word)
                    EditWordView(word: word)
                } label: {
                    HStack {
                        Text(word.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        ButtonsImages.checkmark.opacity(word.isInList ? 1 : 0)
                    }
                }
                .swipeActions {
                    Button {
                        swipeAction(for: word)
                    } label: {
                        Text(word.isInList ? "Убрать из списка" : "Добавить в список")
                    }
                    .tint(word.isInList ? .gray : .green)
                }
            }
            .listStyle(.plain)
            
            Spacer()
            
            DismissButton()
        }
        // MARK: Выполняется при  появлении экрана
        .task {
            await appearAction()
        }
        .onAppear {
            tabbarState.tabBarIsHidden = true
        }
        
        .navigationBarBackButtonHidden(true)
    }
    
    private func appearAction() async {
        let words = Words(words: store.baseWordsStore.getAll())
        autoCompleteWord.words = await words.lookUp(searchWord)
    }
    
    private func swipeAction(for word: WordModel) {
        var word = word
        if !word.isInList {
            word.addInList()
        } else {
            word.removeFromList()
        }
        
        Task {
            await store.baseWordsStore.update(set: word)
            await store.baseWordsStore.saveInFileManager()
        }
        autoCompleteWord.updWord(word)
    }
}

#Preview {
    SearchWordView()
        .environmentObject(Store())
        .environmentObject(TabBarState())
}

private actor Words {
    let words: [WordModel]
    
    init(words: [WordModel]) {
        self.words = words
    }
    
    func lookUp(_ prefix: String) -> [WordModel] {
        return words.filter { $0.body.contains(prefix) }
    }
}

@MainActor
class AutoCompleteWord: ObservableObject {
    @Published var words: [WordModel] = []
    let storedWards: [WordModel]
    init(words: [WordModel]) {
        self.storedWards = words
    }
    
    private var task: Task<Void, Never>?
    
    func ar(word value: String) -> [WordModel] {
        autoComplete(value)
        return words
    }
    
    func autoComplete(_ text: String) {
//        guard !text.isEmpty else {
//            words = []
//            task?.cancel()
//            return
//        }
        
        task?.cancel()
        
        task = Task {
            try? await Task.sleep(nanoseconds: 100000)
            guard !Task.isCancelled else {
                return
            }
            
            let newWords = await Words(words: words).lookUp(text)
            
            words = newWords
        }
    }
    
    func updWord(_ word: WordModel) {
        guard let index = words.firstIndex(where: { $0.id == word.id }) else { return }
        words[index] = word
    }
}

