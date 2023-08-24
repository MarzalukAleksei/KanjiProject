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
                    ForEach(findKanji(), id:\.self) { kanji in
                        WordRowView(kanji: kanji)
                        .padding(.horizontal, Settings.padding)
                    }
                    
                    .frame(minHeight: PartsSize.learningCellHeight)
                    .modifier(Modifiers.learningCell)
                    
                    ForEach(word.translate, id: \.self) { translate in
                        Text(translate)
                    }
                    
                    ForEach(word.examples, id: \.self) { example in
                        Text(example)
                    }
                }
            }
            
            Spacer()
            
            DismissButton()
        }
        .navigationBarBackButtonHidden(true)
        
        .onAppear {
            
        }
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
                result.append(KanjiModel(body: String(char), kun: "Данный кандзи не входит в 2000 основных кандзи", on: "", translate: "", number: 0, level: 0))
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
