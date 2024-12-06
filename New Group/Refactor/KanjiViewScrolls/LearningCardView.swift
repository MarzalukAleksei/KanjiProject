//
//  LearningCardView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/06/22.
//

import SwiftUI

struct LearningCardView: View {
    @Environment(\.managedObjectContext) private var context
    
    @State private var frontViewAngle = 0.0
    @State private var backViewAngle = 90.0
    @State var number: Int = 0
    @State var isFrontSide = true
    var currentLearning: [KanjiModel]
    let duration = 0.35
    
    @State var curentKanji: KanjiModel
    
    var body: some View {
        VStack {
            ZStack {
                BackSideView(kanji: curentKanji, angle: $backViewAngle)
                FrontSideVIew(kanji: curentKanji, angle: $frontViewAngle)
            }
            .onTapGesture {
                flip()
            }
            
            HStack {
                Button("Back") {
                    changeKanji(index: number - 1)
                }
                
                Spacer()
                
                Button("Next") {
                    changeKanji(index: number + 1)
                }
            }
            .padding(.horizontal, 50)
            
        }
        .padding(.horizontal, 30)
        .padding(.top, 20)
        .padding(.bottom, 70)
    }
    
    private func index(number: Int) -> Int {
        var result = self.number
        if currentLearning.count == 1 {
            return result
        }
        if number >= 0 && number <= currentLearning.count { // срабатывает если это не крайний элемент
            result = number
            isFrontSide = true
            defaultAngle()
        }
        return result
    }
    
    private func changeKanji(index: Int) {
        number = self.index(number: index)
        curentKanji = currentLearning[number]
    }
    
    private func defaultAngle() {
        frontViewAngle = 0
        backViewAngle = 90
    }
    
    private func flip() {
        isFrontSide.toggle()
        if isFrontSide {
            withAnimation(.easeInOut(duration: duration)) {
                frontViewAngle = -90
            }
            withAnimation(.easeInOut(duration: duration).delay(duration)) {
                backViewAngle = 0
            }
        } else {
            withAnimation(.easeInOut(duration: duration)) {
                backViewAngle = 90
            }
            withAnimation(.easeInOut(duration: duration).delay(duration)) {
                frontViewAngle = 0
            }
        }
    }
}

struct LearningCardView_Previews: PreviewProvider {
    static var previews: some View {
        LearningCardView(currentLearning: [.MOCK_KANJI], curentKanji: .MOCK_KANJI)
    }
}
