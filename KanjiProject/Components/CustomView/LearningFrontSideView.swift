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
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Rectangle()
                    .modifier(Modifiers.learningRect)
                VStack {
                    HStack {
                        Text("\(number)" + "/" + "\(count)")
                        
                        Spacer()
                        
                        Text("問" + "\(index)")
                    }
                    .font(CustomFont.scroll(size: geo.size.height / 8))
                    .padding(Settings.padding * 1.8)
                    
                    Spacer()
                }
                Text(kanji.body)
                    .font(.system(size: geo.size.height / 3))
                    .bold()
            }
        }
    }
}

struct LearningFrontSideView_Previews: PreviewProvider {
    static var previews: some View {
        LearningFrontSideView(index: 32, kanji: .MOCK_KANJI, number: 3, count: 20)
            .frame(width: 380, height: 250)
            .background(Color.black)
            
    }
}
