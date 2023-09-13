//
//  LearningFrontSideView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/10.
//

import SwiftUI

struct LearningFrontSideView: View {
    let index: Int
    let kanji: KanjiModel
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
                    Text(kanji.body)
                        .font(.system(size: geo.size.height / 3))
                    .bold()
                    
                    // отступ от нижней границы
                    Text(" ")
                }
            }
        }
    }
}

struct LearningFrontSideView_Previews: PreviewProvider {
    static var previews: some View {
        LearningFrontSideView(index: 32, kanji: .MOCK_KANJI, number: 3, count: 20, type: "漢")
            .frame(width: 380, height: 250)
            .background(Color.black)
            
    }
}
