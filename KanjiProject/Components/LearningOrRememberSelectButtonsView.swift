//
//  KankenSelectView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/06/14.
//

import SwiftUI

struct LearningOrRememberSelectButtonsView: View {
    @Binding var showLearningView: Bool
//    @Binding var showLearningByKanjiSecondVar: Bool
//    @Binding var showCheckView: Bool
//    @Binding var showLearnigByWord: Bool
    
    var body: some View {
        VStack {
//            Button(action: {
//                showLearningView = true
//            }, label: {
//                Text("Учить кандзи")
//                    .frame(maxWidth: .infinity)
//                    .frame(height: ElementSize.modalViewButtonHeight)
//                    .background {
//                        Color.black
//                    }
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//            })
            
            Button {
                showLearningView = true
            } label: {
                Text("Учить кандзи")
                    .frame(maxWidth: .infinity)
                    .frame(height: ElementSize.modalViewButtonHeight)
                    .background {
                        Color.black
                    }
                    .foregroundStyle(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: Settings.buttonsCornerRadius))
            }
        }
        .padding(.horizontal, Settings.padding)
    }
}

#Preview {
    LearningOrRememberSelectButtonsView(showLearningView: .constant(false))
}
