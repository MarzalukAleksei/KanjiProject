//
//  BaseWordsSelectLevelView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/02/06.
//

import SwiftUI

struct BaseWordsSelectLevelView: View {
    @EnvironmentObject var store: Store
    @AppStorage("baseWordLevel") var wordLevel: NouryokuLevel = .N5
    @Binding var currentLevel: NouryokuLevel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Settings.paddingBetweenElements) {
                ForEach(NouryokuLevel.allCases.reversed(), id: \.self) { level in
                    if level != .another {
                        LevelButton(level: level, array: store.baseWords.get(level: level), size: ElementSize.levelButtonSize, color: currentLevel == level ? .gray : .black)
                            .onTapGesture {
                                withAnimation(Settings.animation) {
                                    wordLevel = level
                                    currentLevel = level
                                }
                            }
                    }
                }
            }
            .padding(.horizontal, Settings.padding)
        }
    }
}

#Preview {
    BaseWordsSelectLevelView(currentLevel: .constant(.N5))
        .environmentObject(Store())
}
