//
//  WordLearningView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/02/06.
//

import SwiftUI

struct WordLearningView: View {
    @EnvironmentObject private var tabBar: TabBarState
    @EnvironmentObject private var store: Store
    @Environment(\.dismiss) private var dismiss

    let level: NouryokuLevel
    @State var currentWord: WordModel
    @State private var meaningInRussian: String = ""
    @State private var presentAlert = false
    @State private var presentDeleteAlert = false
    
    var body: some View {
        VStack {
            let tR: [TextAndReading] = setTR()
            WordWithFuriganaView(word: tR, currentKanji: .empty, readingIsHidden: false)
            
            Text(currentWord.meaningInEnglish)
                .padding(.horizontal, 20)
            
            Text(meaningInRussian)
                .foregroundStyle(.blue)
                .padding(.horizontal, 20)
            
            HStack(spacing: 5) {
                TextField("Ввести значение самостоятельно", text: $meaningInRussian)
                    .textFieldStyle(.roundedBorder)
                Button {
                    presentDeleteAlert = true
                } label: {
                    ButtonsImages.trashImage
                        .frame(width: 20, height: 20)
                }

            }
            .padding()
            .alert("Точно удаляем?", isPresented: $presentDeleteAlert) {
                
                Button(role: .destructive) {
                        deleteAction()
                    } label: {
                        Text("ДА")
                    }
            }
            
            Button(action: {
                saveAction()
            }, label: {
                Text("СОХРАНИТЬ ЗНАЧЕНИЕ СЛОВА")
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .font(.system(size: 20))
                    .background(.green)
                    .foregroundStyle(.black)
            })
            
            List(findTranslate(), id: \.self) { word in
                ZStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(word.body)
                                .foregroundStyle(.red)
                            Text(word.reading)
                                .foregroundStyle(.brown)
                        }
                        ForEach(word.translate, id: \.self) { row in
                            Text(row)
                        }
                    }
                    Color.orange
                        .opacity(0.05)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        
                    } label: {
                        Text("SAVE THIS")
                    }

                }
                .onTapGesture {
                    print(word.body)
                    meaningInRussian = word.translate.joined(separator: "・")
                }
            }
            
            Spacer()
            
            Button {
                addWordToLearningList()
            } label: {
                Text(currentWord.isInList ? "Убрать из списка" : "Добавить в список на изучение")
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .font(.system(size: 20))
                    .background(currentWord.isInList ? .blue.opacity(0.7) : .purple.opacity(0.7))
                    .foregroundStyle(.black)
            }
            
            Button(action: {
                Task {
                    do {
                        try await nextWord()
                    } catch {
                        presentAlert = true
                    }
                }
            }, label: {
                Text("СЛЕДУЮЩЕЕ СЛОВО")
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .font(.system(size: 20))
                    .background(.brown)
                    .foregroundStyle(.black)
            })
            
            DismissButton()
        }
        .alert("Элементов более не осталось", isPresented: $presentAlert, actions: {
            Button("Close") {dismiss()}
        })
        .onAppear {
            tabBar.tabBarIsHidden = true
            print(store.baseWordsStore.getAll(for: level).filter { $0.meaningInRussian == "" }.count)
            Task {
                do {
                    if level != .another {
                        try await nextWord()
                    } else {
                        meaningInRussian = currentWord.meaningInRussian
                    }
                } catch {
                    presentAlert = true
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func addWordToLearningList() {
        if currentWord.isInList {
            currentWord.removeFromList()
        } else {
            currentWord.addInList()
        }
        
        Task {
            await save(currentWord)
        }
    }
    
    private func isWordInList() -> Bool {
        currentWord.isInList
    }
    
    private func deleteAction() {
        let currentWord = currentWord
        print("current word deleted")
        Task {
//            await store.baseWordsStore.delete(currentWord)
            await save(currentWord)
            do {
                try await nextWord()
            } catch {
                presentAlert = true
            }
        }
    }
    
    private func saveAction() {
        var word = currentWord
        word.meaningInRussian = meaningInRussian
        Task {
//            await store.baseWordsStore.update(set: word)
            await save(word)
            do {
//                if level != .another {
                    try await nextWord()
//                } else {
//                    dismiss()
//                }
            } catch {
                presentAlert = true
            }
        }
    }
    
//    private func
    
    private func save(_ word: WordModel) async {
        await store.baseWordsStore.update(set: word)
        let data = JSONManager.manager.encodeToJSON(store.baseWordsStore.getAll())
        JSONManager.manager.saveJSONToFile(data, fileName: .baseWords)
    }
    
    private func nextWord() async throws {
        var allWords: [WordModel] = []
        if level != .another {
            allWords = store.baseWordsStore.getAll(for: level)
        } else {
            allWords = store.baseWordsStore.getAll()
        }
        let words = allWords.filter { $0.meaningInRussian == "" }
        meaningInRussian = ""
        if let word = words.randomElement() {
            currentWord = word
        } else {
            throw MyErrors.noWordsLeft
        }
    }
    
    private func findTranslate() -> [DictionaryModel] {
        let dictionary = store.dictionaryStore.getAll()
        var word = currentWord
        
        if word.reading.components(separatedBy: " ").count > 1 {
            word.body.removeFirst()
        }
            
        let filtered = dictionary.filter { $0.body.contains(word.body) }
        return filtered
    }
    
    private func setTR() -> [TextAndReading] {
        var result: [TextAndReading] = []
        let components = currentWord.reading.components(separatedBy: " ")
        for part in components {
            if part.contains("[") {
                guard let startIndex = part.firstIndex(of: "["),
                      let endIndex = part.firstIndex(of: "]") else { return [] }
                
                let text = String(part[part.startIndex..<startIndex] + part[part.index(after: endIndex)..<part.endIndex])
                let reading = String(part[part.index(after: startIndex)..<endIndex])
                
                result.append(TextAndReading(text: text, reading: reading))
            } else if components.count < 2 {
                result.append(TextAndReading(text: currentWord.body, reading: currentWord.reading))
            } else {
                result.append(TextAndReading(text: part, reading: ""))
            }
        }
        return result
    }
}

#Preview {
    WordLearningView(level: .N5,
                     currentWord: Store().baseWordsStore.getAll(for: .N5).randomElement() ?? .MOCK)
        .environmentObject(TabBarState())
        .environmentObject(Store())
}
