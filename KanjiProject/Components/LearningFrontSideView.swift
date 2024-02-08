//
//  LearningFrontSideView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/10.
//

import SwiftUI

struct LearningFrontSideView: View {
    let index: Int
    let kanji: Any
    let number: Int
    let count: Int
    let type: String
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Rectangle()
                    .modifier(Modifiers.learningRect)
                VStack {
                    HStack {
                        Text("\(number)" + "/" + "\(count)")
                        
                        Spacer()
                        
                        Text(type + "\(index)")
                    }
                    .font(CustomFont.scroll(size: geo.size.height / 8))
                    .padding(.horizontal ,Settings.padding * 1.8)
                    .padding(.top, Settings.padding * 0.8)
                    
                    Spacer()
                }
                VStack {
                    Text(getBody())
                        .font(CustomFont.main(size: geo.size.height / 2.5))
                    .bold()
                    
                    // отступ от нижней границы
                    Text(" ")
                }
            }
        }
    }
    private func getBody() -> String {
        switch kanji {
        case is KanjiModel:
            guard let kanji = kanji as? KanjiModel else { return "" }
            return kanji.body
        case is KanjiKankenModel:
            guard let kanji = kanji as? KanjiKankenModel else { return "" }
            return kanji.body
        case _: break
        }
        return ""
    }
}

struct LearningFrontSideView_Previews: PreviewProvider {
    static var previews: some View {
        LearningFrontSideView(index: 32, kanji: KanjiModel.MOCK_KANJI, number: 3, count: 20, type: "漢")
            .frame(width: 380, height: 250)
            .background(Color.black)
            
    }
}
