//
//  WordLearningView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/02/06.
//

import SwiftUI

struct WordLearningView: View {
    @EnvironmentObject var tabBar: TabBarState
    @EnvironmentObject var store: Store
    @Environment(\.dismiss) var dismiss

    let level: NouryokuLevel
    @State var currentWord: WordModel
    @State var meaningInRussian: String = ""
    @State var presentAlert = false
    
    var body: some View {
        VStack {
            let tR: [TextAndReading] = setTR()
            WordWithFuriganaView(word: tR, currentKanji: .empty, readingIsHidden: false)
            
            Text(currentWord.meaningInEnglish)
                .padding(.horizontal, 20)
            
            Text(meaningInRussian)
                .foregroundStyle(.blue)
                .padding(.horizontal, 20)
            
            TextField("Ввести значение самостоятельно", text: $meaningInRussian)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            Button(action: {
                var word = currentWord
                word.meaningInRussian = meaningInRussian
                store.baseWords.update(set: word)
                Task {
                    await save()
                }
                    do {
                        try nextWord()
                    } catch {
                        presentAlert = true
                    }
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
                        Text(word.body)
                            .foregroundStyle(.red)
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
            
            Button(action: {
                do {
                    try nextWord()
                } catch {
                    presentAlert = true
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
            print(store.baseWords.get(level: level).filter { $0.meaningInRussian == "" }.count)
            do {
                try nextWord()
            } catch {
                presentAlert = true
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func save() async {
        let data = JSONManager.methoods.encodeToJSON(store.baseWords.getAll())
        JSONManager.methoods.saveJSONToFile(data, fileName: .baseWords)
    }
    
    func nextWord() throws {
        let allWords = store.baseWords.get(level: level)
        let words = allWords.filter { $0.meaningInRussian == "" }
        meaningInRussian = ""
        if let word = words.randomElement() {
            currentWord = word
        } else {
            throw RandomWordError.noWordsLeft
        }
    }
    
    func findTranslate() -> [DictionaryModel] {
        let dictionary = store.dictionaryStore.getAll()
        var word = currentWord
        
        if word.reading.components(separatedBy: " ").count > 1 {
            word.body.removeFirst()
        }
            
        let filtered = dictionary.filter { $0.body.contains(word.body) }
        return filtered
    }
    
    func setTR() -> [TextAndReading] {
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
                     currentWord: Store().baseWords.get(level: .N5).randomElement() ?? .MOCK)
        .environmentObject(TabBarState())
        .environmentObject(Store())
}
