//
//  KankenKanjiLearningView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/11/04.
//

import SwiftUI

struct KankenKanjiLearningView: View {
    @EnvironmentObject private var tabBarState: TabBarState
    @AppStorage("selectedRow") var selectedRow: Data?
    @State private var currentIndex = 0
    let kankenFlow: KankenFlow
    var currentKanji: KanjiKankenModel {
        kankenFlow.kanji[currentIndex]
    }
    var body: some View {
        VStack(/*alignment: .leading*/) {
            ZStack {
                CustomNavigationBarView(corners: [.bottomLeft, .bottomRight],
                                        cornerRadius: Settings.learningViewCornerRadius,
                                        heigh: ElementSize.learningViewNavigationBarHeght)
                LearningFrontSideView(index: kankenFlow.index,
                                      kanji: kankenFlow.kanji[currentIndex],
                                      number: currentIndex + 1,
                                      count: kankenFlow.kanji.count,
                                      type: "")
                BackForwardClearButtons(currentIndex: $currentIndex, kanji: kankenFlow.kanji)
                
            }
            .frame(maxHeight: ElementSize.learningViewNavigationBarHeght)
            
            Button("Print current") {
                print(currentKanji.examples)
                print(" ")
                print(currentKanji.getExamplesWithReading()[.外])
            }
            
            ScrollView {
                VStack(spacing: Settings.paddingBetweenText) {
                    ForEach(SchoolLevel.allCases, id: \.self) { type in
                        if let row = getKunReading(type) {
                            KankenReadingRowView(row: row, type: type)
                        }
                    }
                    
                    ForEach(SchoolLevel.allCases, id: \.self) { type in
                        if let row = getOnReading(type) {
                            KankenReadingRowView(row: row, type: type)
                        }
                    }
                }
                
                Divider()
                
                HStack {
                    Text(currentKanji.meaning)
                    Spacer()
                }
                .padding(.horizontal, Settings.padding)
                
                Divider()
                
                KankenExamplesRowView(currentKankenKanji: kankenFlow.kanji[currentIndex])
            }
            
            Spacer()
            
            DismissButton()
        }
        
        .onAppear {
            tabBarState.tabBarIsHidden = true
            selectedRow = encodeData(kankenFlow.kanji, row: kankenFlow.index) // Сохранение в памяти какая ячейка была открыта
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func encodeData(_ kanji: [KanjiKankenModel], row: Int) -> Data {
        guard let kanji = kanji.first,
              let result = try? JSONEncoder().encode(SelectedKankenRow(row: row, level: kanji.kankenLevel)) else { return Data() }
        return result
    }
    
    func getKunReading(_ type: SchoolLevel) -> String? {
        return kankenFlow.kanji[currentIndex].kunReading[type]
    }
    
    func getOnReading(_ type: SchoolLevel) -> String? {
        return kankenFlow.kanji[currentIndex].onReading[type]
    }
}

#Preview {
    KankenKanjiLearningView(kankenFlow: .ANOTHER_MOCK)
        .environmentObject(TabBarState())
}

#Preview {
    KankenKanjiLearningView(kankenFlow: .MOCK)
        .environmentObject(TabBarState())
}
