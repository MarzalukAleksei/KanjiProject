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
    @State private var currentKanjiIndex = 0
    let kankenFlow: KankenFlow
    var currentKanji: KanjiKankenModel {
        kankenFlow.kanji[currentKanjiIndex]
    }
    var body: some View {
        VStack {
            ZStack {
                CustomNavigationBarView(corners: [.bottomLeft, .bottomRight],
                                        cornerRadius: Settings.learningViewCornerRadius,
                                        heigh: ElementSize.learningViewNavigationBarHeght)
                LearningFrontSideView(index: kankenFlow.index,
                                      kanji: kankenFlow.kanji[currentKanjiIndex],
                                      number: currentKanjiIndex + 1,
                                      count: kankenFlow.kanji.count,
                                      type: "")
            }
            .frame(maxHeight: ElementSize.learningViewNavigationBarHeght)
            ScrollView {
                ForEach(SchoolLevel.allCases, id: \.self) { type in
                    if let row = getKunReading(type) {
                        Text(type.rawValue)
                            .font(.system(size: 30))
                        Text(row)
                    }
                }
                
                ForEach(SchoolLevel.allCases, id: \.self) { type in
                    if let row = getOnReading(type) {
                        Text(type.rawValue)
                            .font(.system(size: 30))
                        Text(row)
                    }
                }
                
                KankenExamplesRowView(currentKankenKanji: kankenFlow.kanji[currentKanjiIndex])
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
        return kankenFlow.kanji[currentKanjiIndex].kunReading[type]
    }
    
    func getOnReading(_ type: SchoolLevel) -> String? {
        return kankenFlow.kanji[currentKanjiIndex].onReading[type]
    }
}

#Preview {
    KankenKanjiLearningView(kankenFlow: .MOCK)
        .environmentObject(TabBarState())
}
