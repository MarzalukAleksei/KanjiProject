//
//  KankenSelectView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/06/14.
//

import SwiftUI

struct LearningOrRememberSelectButtonsView: View {
    @Binding var showLearningView: Bool
    
    var body: some View {
        VStack {
            Button(action: {
                showLearningView = true
            }, label: {
                Text("Учить")
                    .frame(maxWidth: .infinity)
                    .frame(height: ElementSize.modalViewButtonHeight)
                    .background {
                        Color.black
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            })
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("Проверить")
            })
//            Spacer()
        }
        .padding(.horizontal, Settings.padding)
    }
}

#Preview {
    LearningOrRememberSelectButtonsView(showLearningView: .constant(false))
}
