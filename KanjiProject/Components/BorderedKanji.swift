//
//  BorderedKanji.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/06/29.
//

import SwiftUI

struct BorderedKanji: View {
    let currentKanji: KanjiKankenModel?
    let action: () -> Void
    
    init(currentKanji: KanjiKankenModel?, action: @escaping () -> Void = {}) {
        self.currentKanji = currentKanji
        self.action = action
    }
    
    var body: some View {
        if let currentKanji = currentKanji {
                Text(currentKanji.body)
                    .font(.system(size: TextSizes.kanjiSize))
                    .padding(.horizontal, TextSizes.kanjiSize * 0.3 / 2)
                    .border(Color.black, width: 1)
                        .onTapGesture {
                            action()
                        }
        }
    }
}

#Preview {
    BorderedKanji(currentKanji: .MOCK_KANJIKANKEN)
}
