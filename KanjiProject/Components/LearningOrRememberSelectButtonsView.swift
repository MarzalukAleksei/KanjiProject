//
//  KankenSelectView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/06/14.
//

import SwiftUI

struct LearningOrRememberSelectButtonsView: View {
    @Binding var showLearningView: Bool
    @Binding var showLearningByKanjiSecondVar: Bool
    @Binding var showCheckView: Bool
    @Binding var showLearnigByWord: Bool
    
    var body: some View {
        VStack {
            Button(action: {
                showLearningView = true
            }, label: {
                Text("Учить кандзи")
                    .frame(maxWidth: .infinity)
                    .frame(height: ElementSize.modalViewButtonHeight)
                    .background {
                        Color.black
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            })
            
            Button {
                showLearningByKanjiSecondVar = true
            } label: {
                Text("Учить кандзи, второй вариант")
                    .frame(maxWidth: .infinity)
                    .frame(height: ElementSize.modalViewButtonHeight)
                    .background {
                        Color.black
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            
            Button(action: {
                showCheckView = true
            }, label: {
                Text("Проверить слово")
                    .frame(maxWidth: .infinity)
                    .frame(height: ElementSize.modalViewButtonHeight)
                    .background {
                        Color.purple
                            .opacity(0.3)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            })
            
            Button(action: {
                showLearnigByWord = true
            }, label: {
                Text("Учить по словам")
                    .frame(maxWidth: .infinity)
                    .frame(height: ElementSize.modalViewButtonHeight)
                    .background {
                        Color.purple
                            .opacity(0.3)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            })
        }
        .padding(.horizontal, Settings.padding)
    }
}

#Preview {
    LearningOrRememberSelectButtonsView(showLearningView: .constant(false), 
                                        showLearningByKanjiSecondVar: .constant(false),
                                        showCheckView: .constant(false),
                                        showLearnigByWord: .constant(false))
}
