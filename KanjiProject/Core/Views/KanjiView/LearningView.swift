//
//  LearningView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/10.
//

import SwiftUI

struct LearningView: View {
    @Environment(\.dismiss) var dismiss
    
    var kanji: [KanjiModel]
    
    init(kanji: [KanjiModel]) {
        self.kanji = kanji
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        VStack {
            
            ZStack {
                CustomNavigationBarView(corners: [.bottomLeft, .bottomRight],
                                        cornerRadius: Settings.learningViewCornerRadius,
                                        heigh: PartsSize.learningViewNavigationBarHeght)
                
                RoundedRectangle(cornerRadius: Settings.learningViewCornerRadius)
                    .foregroundColor(.white)
                    .padding(Settings.padding)
            }
            .frame(maxHeight: PartsSize.learningViewNavigationBarHeght)
            
            
            
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
    
}

struct LearningView_Previews: PreviewProvider {
    static var previews: some View {
        LearningView(kanji: [.MOCK_KANJI, .MOCK_KANJI, .MOCK_KANJI])
    }
}
