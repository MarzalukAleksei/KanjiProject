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
                
                    NavigationLink(destination: CreateWordView(_body: searchWord)) {
                        ButtonsImages.pencil
                            .foregroundStyle(.white)
                    }
                }
                .padding(20)
            }
            .frame(height: 40)
            
            List(autoCompleteWord.words) { word in
                NavigationLink {
                    WordLearningView(level: .another, currentWord: word)
                } label: {
                    Text(word.body)
                }

            }
            
            Spacer()
            
            DismissButton()
        }
        
        .onAppear {
            tabbarState.tabBarIsHidden = true
            let word = searchWord
            searchWord = ""
            Task {
                try? await Task.sleep(nanoseconds:10000000)
                searchWord = word
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
//    func findWord() async -> [WordModel] {
//        return await withUnsafeContinuation { continuation in
//            Task {
//                let result = store.baseWordsStore.getAll().filter { $0.body == searchWord }
//                return result
//            }
//        }
//    }
}

#Preview {
    SearchWordView()
        .environmentObject(Store())
        .environmentObject(TabBarState())
}

actor Words {
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
    
    func autoComplete(_ text: String) {
        guard !text.isEmpty else {
            words = []
            task?.cancel()
            return
        }
        
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
}

