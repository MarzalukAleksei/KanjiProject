//
//  KankenSelectView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/06/14.
//

import SwiftUI

struct LearningOrRememberSelectButtonsView: View {
    @AppStorage("kanjiTypeSlider") private var toggleInStorage: Bool = false
    @AppStorage("selectedNouryokuLevel") private var selectedNouryokuLevel: NouryokuLevel = .N5
    @AppStorage("selectedKankenLevel") private var selectedKankenLevel: KankenLevel = .級10
    @EnvironmentObject private var coordinator: Coordinator
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
                coordinator.cover(by: .kanjiLearningView(kankenIsSelected: toggleInStorage,
                                                         jlpt: selectedNouryokuLevel,
                                                         kanken: selectedKankenLevel))
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
        .environmentObject(Coordinator())
}
