//
//  WordDetailView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/21.
//

import SwiftUI

struct WordDetailView: View {
    
    let word: DictionaryModel
    @EnvironmentObject private var store: Store
    @EnvironmentObject private var tabBarState: TabBarState
    @State private var selectedKanji: KanjiModel? = nil
    @State private var linskTapped = false
    @State private var links: Links? = nil
    @State private var moveTo: MoveTo = MoveTo(word: .MOCK_DICTIONARY)
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBarView(title: word.body,
                                    corners: .bottomRight,
                                    cornerRadius: ElementSize.navigationCornerRadius,
                                    heigh: ElementSize.wordDetailViewNavigationBarHight)
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
                    .frame(minHeight: ElementSize.learningCellHeight)
                    .modifier(Modifiers.learningCell)
                    
                    // ПРИМЕРЫ
                    
                    ForEach(word.examples, id: \.self) { example in
// MARK: Проверка на наличие с строке ссылки. Ссылка в тексте обозначена скобками <<< >>>
                        if example.contains("<<<") {
                            let words: [DictionaryModel] = example.textAndLinks().filter { !$0.isText }.map { findWord(by: $0.text) }
// MARK: Если в строке есть только одна ссылка, то перейти в WordDetailView
                            if words.count < 2 {
                                NavigationLink {
                                    WordDetailView(word: words[0])
                                } label: {
                                    WordExampleView(text: example)
                                        .multilineTextAlignment(.leading)
                                        .foregroundStyle(.black)
                                }
                            } else {
// MARK: Если ссылок больче чем одна, то присвоить links.words массив ссылок. Изменение links вызывает ModalView
                                Button(action: {
                                    self.links = Links(words: words)
                                }, label: {
                                    WordExampleView(text: example)
                                        .multilineTextAlignment(.leading)
                                })
                                .foregroundStyle(.black)
                            }
                        } else {
                            WordExampleView(text: example)
                        }
                    }
                    .padding(.horizontal, Settings.padding)
                }
            }
            
            Spacer()
            
            DismissButton()
        }
        .navigationBarBackButtonHidden(true)
        
// MARK: Переход на выбранное из всплывающего ModalView слова
        .navigationDestination(isPresented: $moveTo.isActive, destination: {
            WordDetailView(word: moveTo.word)
                .onAppear {
                    links = nil
                }
        })
        
        .onAppear {
            tabBarState.tabBarIsHidden = true
        }
        
        .sheet(item: $selectedKanji, content: { kanji in
                KanjiToUserListView(kanji: kanji)
        })
        
// MARK: ModalView всплывающий если в строке больше чем одна ссылка
        .sheet(item: $links) { links in
            let height = (ElementSize.modalViewButtonHeight + (Settings.paddingBetweenText * 2)) * CGFloat(links.words.count)
            ModalViewButtons(links: links, moveTo: $moveTo)
                .padding(.vertical, Settings.paddingBetweenText)
                .presentationDetents([.height(height)])
            
        }
        
    }
    
    func findWord(by link: String) -> DictionaryModel {
        store.dictionaryStore.getAll().first(where: { $0.number == link }) ?? .MOCK_DICTIONARY
        
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
            .environmentObject(TabBarState())
    }
}
