//
//  ModalViewButtons.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/09/28.
//

import SwiftUI

struct ModalViewButtons: View {
    let links: Links
    @Binding var moveTo: MoveTo
    
    var body: some View {
        VStack(spacing: Settings.paddingBetweenText) {
            ForEach(links.words, id: \.self) { word in
                Button(action: {
                    moveTo.word = word
                    moveTo.isActive = true
                }, label: {
                    CustomButton(word: word)
                })
                .frame(maxWidth: .infinity)
                .frame(height: ElementSize.modalViewButtonHeight)
                .foregroundStyle(.black)
                .padding(.horizontal, Settings.padding)
            }
        }
        .padding(.top, Settings.padding / 2)
    }
}

fileprivate struct CustomButton: View {
    let word: DictionaryModel
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Settings.modalViewButtonCornerRadius)
                .stroke(lineWidth: 2)
            HStack {
                Text(word.body)
                Text(word.reading)
                
                Spacer()
                
                ButtonsImages.chevronRight
            }
            .padding(.horizontal, Settings.paddingBetweenText)
        }
    }
}

#Preview {
    ModalViewButtons(links: Links(words: [.MOCK_DICTIONARY]), moveTo: .constant(MoveTo(word: .MOCK_DICTIONARY)))
        .frame(width: 300, height: 70)
}
