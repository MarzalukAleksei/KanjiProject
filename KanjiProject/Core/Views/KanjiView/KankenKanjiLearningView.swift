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
//    @State var image: AsyncImage<Image>?
    
    let kankenFlow: KankenFlow
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
                    .readSize { size in
                        print(size.width, size.height)
                    }
                
            }
            .frame(maxHeight: ElementSize.learningViewNavigationBarHeght)
            
            // MARK: KanjiDetail
            KanjiDetailView(currentKanji: setCurrentKanji())
            
            Spacer()
            
            DismissButton()
        }
//        .onChange(of: currentIndex, perform: { value in
//            currentKanji = setCurrentKanji()
//        })
        
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
    
    func setCurrentKanji() -> KanjiKankenModel {
        kankenFlow.kanji[currentIndex]
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


