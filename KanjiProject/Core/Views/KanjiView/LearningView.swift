//
//  LearningView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/10.
//

import SwiftUI

struct LearningView: View {
    
    @EnvironmentObject private var store: Store
    @EnvironmentObject private var tabBarState: TabBarState
    @AppStorage("selectedRow") var selectedRow: Data?
    
    var kanjiFlow: KanjiFlow
    @State private var currentKanjiIndex = 0
    
    var body: some View {
        VStack {
            
            ZStack {
                CustomNavigationBarView(corners: [.bottomLeft, .bottomRight],
                                        cornerRadius: Settings.learningViewCornerRadius,
                                        heigh: ElementSize.learningViewNavigationBarHeght)
                
                LearningFrontSideView(index: kanjiFlow.index,
                                      kanji: kanjiFlow.kanji[currentKanjiIndex],
                                      number: currentKanjiIndex + 1,
                                      count: kanjiFlow.kanji.count,
                                      type: kanjiFlow.type)
                    
            }
            .frame(maxHeight: ElementSize.learningViewNavigationBarHeght)
            .onTapGesture {
                var kanji = kanjiFlow.kanji[currentKanjiIndex]
                kanji.lastAnswerRight = true
                withAnimation(Settings.animation) {
                    addIndex()
                    store.updateKanji(kanji)
                }
//                reduceIndex()
            }
            
            ScrollView {
                LazyVStack(spacing: Settings.paddingBetweenElements + 1){
                    LearningCell(title: "訓読み:", kanji: kanjiFlow.kanji[currentKanjiIndex], type: .kun)
                        .modifier(Modifiers.learningCell)
                    
                    LearningCell(title: "音読み:", kanji: kanjiFlow.kanji[currentKanjiIndex], type: .on)
                        .modifier(Modifiers.learningCell)
                    
                    LearningCell(title: "Значение:", kanji: kanjiFlow.kanji[currentKanjiIndex], type: .translate)
                        .modifier(Modifiers.learningCell)
                    
                    HStack {
                        Text("Примеры:")
                            .opacity(Settings.opacity)
                        Spacer()
                    }
                    
                    ForEach(examples(), id: \.self) { exp in
                        NavigationLink(value: exp) {
//                            LearningCell(title: "Примеры:", type: .examples, dictionary: exp)
                            LearningCell(title: "Примеры", type: .examples, dictionary: exp, chevronForwardIsHidden: false)
                                .modifier(Modifiers.learningCell)
                                .multilineTextAlignment(.leading)
                                
                        }
                        
//                        .buttonStyle(.plain)
                        .foregroundColor(.black)
                    }
                }
            }
            .padding(.horizontal, Settings.padding - 1)
//            .padding(.top, Settings.paddingBetweenElements)
            
            Spacer()
            
            DismissButton()

        }
        .onAppear {
            tabBarState.tabBarIsHidden = true
            selectedRow = encodeData(kanjiFlow.kanji, row: kanjiFlow.index)
        }
        .navigationBarBackButtonHidden(true)
        
        .navigationDestination(for: DictionaryModel.self) { word in
            WordDetailView(word: word)
        }
    }
    
    func encodeData(_ kanji: [KanjiModel], row: Int) -> Data {
        guard let kanji = kanji.first,
              let result = try? JSONEncoder().encode(SelectedKanjiRow(level: kanji.level, row: kanjiFlow.index)) else { return Data() }
        return result
    }
    
    func addIndex() {
        if currentKanjiIndex < kanjiFlow.kanji.count - 1 {
            currentKanjiIndex += 1
        }
    }
    
    func reduceIndex() {
        if currentKanjiIndex > 0 {
            currentKanjiIndex -= 1
        }
    }
    
    func examples() -> [DictionaryModel] {
        let kanji = kanjiFlow.kanji[currentKanjiIndex]
        let result = store.dictionaryStore.getAll().filter {
            $0.body.contains(kanji.body)
        }.sorted {
            $0.body.count < $1.body.count
//            $0.body < $1.body
        }
        
        return result
    }
}

struct LearningView_Previews: PreviewProvider {
    static var previews: some View {
        LearningView(kanjiFlow: .MOCK_KANJIFLOW)
            .environmentObject(Store())
            .environmentObject(TabBarState())
    }
}
