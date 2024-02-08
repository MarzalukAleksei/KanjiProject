//
//  BackForwardClearButtons.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/01/20.
//

import SwiftUI

struct BackForwardClearButtons: View {
    @Binding var currentIndex: Int
    let kanji: [KanjiKankenModel]
    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .opacity(0.000001)
                .onTapGesture {
                    withAnimation(Settings.animation) {
                        reduceIndex()
                    }
                }
                .overlay {
                    HStack {
                        ButtonsImages.arrowBackward
                            .resizable()
                            .frame(width: 30, height: 25)
                        Spacer()
                    }
                    .opacity(currentIndex == 0 ? 0 : 1)
                    .padding(.leading, Settings.padding + 10)
                }
            Rectangle()
                .opacity(0.000001)
                .onTapGesture {
                    withAnimation(Settings.animation) {
                        addIndex()
                    }
                }
                .overlay {
                    HStack {
                        Spacer()
                        ButtonsImages.arrowForward
                            .resizable()
                            .frame(width: 30, height: 25)
                    }
                    .opacity(currentIndex == kanji.count - 1 ? 0 : 1)
                    .padding(.trailing, Settings.padding + 10)
                }
        }
    }
    
    func addIndex() {
        if currentIndex < kanji.count - 1 {
            currentIndex += 1
        }
    }
    
    func reduceIndex() {
        if currentIndex > 0 {
            currentIndex -= 1
        }
    }
}

#Preview {
    BackForwardClearButtons(currentIndex: .constant(0), kanji: [.MOCK_KANJIKANKEN, .MOCK_KANJIKANKEN, .MOCK_KANJIKANKEN])
}
