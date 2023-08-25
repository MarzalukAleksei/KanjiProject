//
//  WordDetailView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/21.
//

import SwiftUI

struct WordDetailView: View {
    
    let word: DictionaryModel
    @EnvironmentObject var store: Store
    @State private var selectedKanji: KanjiModel? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBarView(title: word.body,
                                    corners: .bottomRight,
                                    cornerRadius: PartsSize.navigationCornerRadius,
                                    heigh: PartsSize.wordDetailViewNavigationBarHight)
            ZStack {
                Rectangle()
                    .modifier(Modifiers.roundedRectTopLeftBlackPart)
                
                VStack {
                    
                    Text(word.reading)
                }
                .padding(20)
                
            }
            
            ScrollView {
                
                VStack(spacing: Settings.paddingBetweenElements) {
                    ForEach(findKanji()) { kanji in
                        WordRowView(kanji: kanji)
                        .padding(.horizontal, Settings.padding)
                        .onTapGesture {
                            selectedKanji = kanji
                        }
                    }
                    .frame(minHeight: PartsSize.learningCellHeight)
                    .modifier(Modifiers.learningCell)
                    
                    // ПЕРЕВОДЫ
                    
                    ForEach(word.translate, id: \.self) { translate in
                        Text(translate)
                    }
                    
                    // ПРИМЕРЫ
                    
                    ForEach(word.examples, id: \.self) { example in
                        // Если есть ссылка #...$#
                        if example.contains("<<<") {
                            Text("TEST")
                                .onAppear {
                                    print(example)
                                    for i in example.textAndLinks() {
                                        print(i.text)
                                    }
                                    
                                }
//                            ForEach(devideToParts(row: example), id: \.self) { row in
//                                HStack {
//                                    Text(row)
//                                    Text(" ")
//                                }
//                            }
//                        } else {
                            Text(example)
                        }
                    }
                }
            }
            
            Spacer()
            
            DismissButton()
        }
        .navigationBarBackButtonHidden(true)
        
        .onAppear {
            
        }
        .sheet(item: $selectedKanji, content: { kanji in
                KanjiToUserListView(kanji: kanji)
        })
        
    }
    
    func findKanji() -> [KanjiModel] {
        var result: [KanjiModel] = []
        
        for char in word.body {
            let finded = store.kanjiStore.getAll().filter { $0.body == String(char) }
            
            if !finded.isEmpty {
                result.append(finded[0])
            } else {
                if store.kanaStore.getAll().contains(where: { $0.hiragana == String(char) }) || store.kanaStore.getAll().contains(where: { $0.katakana == String(char) }) {
                    continue
                }
                // ВРЕМЕННАЯ ЗАТЫЧКА
//                result.append(KanjiModel(body: String(char), kun: "Данный кандзи не входит в 2000 основных кандзи", on: "", translate: "", number: 0, level: 0))
            }
            
        }
        
        return result
    }
}

struct WordDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WordDetailView(word: .MOCK_DICTIONARY)
            .environmentObject(Store())
    }
}
