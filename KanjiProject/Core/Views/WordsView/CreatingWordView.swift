//
//  CreatingWordView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/02/26.
//

import SwiftUI

struct CreateWordView: View {
    @EnvironmentObject var store: Store
    @State var word: WordModel?
    @State var selectedLevel: NouryokuLevel = .another
    @State var _body = ""
    @State var reading = ""
    @State var meaningInRussion = ""
    
    var body: some View {
        VStack {
            Group {
                TextField("Кандзи", text: $_body)
                TextField("Чтение", text: $reading)
                TextField("Значение на русском", text: $meaningInRussion)
            }
            .padding(.horizontal, 20)
            .textFieldStyle(.roundedBorder)
            HStack {
                ForEach(NouryokuLevel.allCases, id: \.self) { level in
                    if level != .another {
                        Button(action: {
                            selectedLevel = level
                        }, label: {
                            Text("\(level.rawValue)")
                                .frame(width: 50, height: 50, alignment: .center)
                                .background(selectedLevel == level ? .cyan : .black)
                                .foregroundStyle(.white)
                                .clipShape(Circle())
                        })
                    }
                }
            }
            .padding(.vertical, 20)
            
            Button(action: {
                saveAction()
            }, label: {
                Text("Сохранить")
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(.green)
                    .foregroundStyle(.black)
            })
            
            List(findTranslate(), id: \.self) { word in
                ZStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(word.body)
                            Text(word.reading)
                            
                        }
                        ForEach(word.translate, id: \.self) { translate in
                            Text(translate)
                        }
                    }
                    Color.white
                        .opacity(0.0000001)
                }
                .onTapGesture {
                    _body = word.body
                    reading = word.reading
                    meaningInRussion = word.translate.joined(separator: "・")
                }

            }
            
            
            Spacer()
            DismissButton()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func save() async {
        let data = JSONManager.manager.encodeToJSON(store.baseWordsStore.getAll())
        JSONManager.manager.saveJSONToFile(data, fileName: .baseWords)
    }
    
    func saveAction() {
        let word = newWord()
        store.baseWordsStore.add(word)
        Task {
            await save()
        }
    }
    
    func newWord() -> WordModel {
        var word = WordModel(body: _body,
                             meaningInEnglish: "",
                             meaningInRussian: meaningInRussion,
                             reading: reading,
                             type: "",
                             levels: [],
                             levelInTag: [selectedLevel])
        word.id = UUID()
        return word
    }
    
    func findTranslate() -> [DictionaryModel] {
        let dictionary = store.dictionaryStore.getAll()
        var word = _body
        
        let filtered = dictionary.filter { $0.body.contains(word) }
        return filtered
    }
}

#Preview {
    CreateWordView()
        .environmentObject(Store())
}

