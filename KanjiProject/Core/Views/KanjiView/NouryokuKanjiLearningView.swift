//
//  LearningView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/10.
//

import SwiftUI

struct NouryokuKanjiLearningView: View {
    
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
//                    store.updateKanji(kanji)
                }
//                reduceIndex()
            }
            
            ScrollView {
                LazyVStack(spacing: Settings.paddingBetweenElements + 1){
// MARK: Кунное чтение
                    LearningCell(kanji: kanjiFlow.kanji[currentKanjiIndex], type: .kun)
                        .modifier(Modifiers.learningCell)
// MARK: Онное чтение
                    LearningCell(kanji: kanjiFlow.kanji[currentKanjiIndex], type: .on)
                        .modifier(Modifiers.learningCell)
// MARK: Перевод
                    LearningCell(kanji: kanjiFlow.kanji[currentKanjiIndex], type: .translate)
                        .modifier(Modifiers.learningCell)
                    
                    HStack {
                        Text("Примеры:")
                            .opacity(Settings.opacity)
                        Spacer()
                    }
// MARK: Примеры
                    ForEach(examples(), id: \.self) { exp in
                        NavigationLink(value: exp) {
                            LearningCell(type: .examples, dictionary: exp, chevronForwardIsHidden: false)
                                .modifier(Modifiers.learningCell)
                                .multilineTextAlignment(.leading)
                                
                        }
                        
                        .foregroundColor(.black)
                    }
                }
            }
            .padding(.horizontal, Settings.padding - 1)
            
            Spacer()
            
            DismissButton()

        }
        .onAppear {
            tabBarState.tabBarIsHidden = true
            selectedRow = encodeData(kanjiFlow.kanji, row: kanjiFlow.index) // Сохранение в памяти какая ячейка была открыта
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
        }
        
        return result
    }
}

struct LearningView_Previews: PreviewProvider {
    static var previews: some View {
        NouryokuKanjiLearningView(kanjiFlow: .MOCK_KANJIFLOW)
            .environmentObject(Store())
            .environmentObject(TabBarState())
    }
}
