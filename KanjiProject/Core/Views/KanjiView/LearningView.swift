//
//  LearningView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/10.
//

import SwiftUI

struct LearningView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var tabBarIsHidden: Bool
    var kanjiFlow: KanjiFlow
    
    @State var index = 0
    
    var body: some View {
        VStack {
            
            ZStack {
                CustomNavigationBarView(corners: [.bottomLeft, .bottomRight],
                                        cornerRadius: Settings.learningViewCornerRadius,
                                        heigh: PartsSize.learningViewNavigationBarHeght)
                
                LearningFrontSideView(index: kanjiFlow.index,
                                      kanji: kanjiFlow.kanji.first ?? .MOCK_KANJI,
                                      number: 1,
                                      count: kanjiFlow.kanji.count)
                    
            }
            .frame(maxHeight: PartsSize.learningViewNavigationBarHeght)
            
            ScrollView {
                Text(kanjiFlow.kanji[index].kun)
            }
            .padding(.horizontal ,Settings.padding)
            .padding(.top, Settings.paddingBetweenElements)
            
            Spacer()
            
            DismissView()
                .onTapGesture {
                    dismiss()
                }

        }
        .onAppear {
            tabBarIsHidden = true
        }
        .navigationBarBackButtonHidden(true)
    }
    
}

struct LearningView_Previews: PreviewProvider {
    static var previews: some View {
        LearningView(tabBarIsHidden: .constant(false), kanjiFlow: .MOCK_KANJIFLOW)
    }
}
