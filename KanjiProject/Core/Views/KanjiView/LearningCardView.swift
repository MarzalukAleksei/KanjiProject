//
//  LearningCardView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/06/22.
//

import SwiftUI

struct LearningCardView: View {
    @EnvironmentObject var stores: Stores
    @State var number: Int = 0
    @State var isFrontSide = true
    var currentLearning: [KanjiModel]
    
    @State var curentKanji: KanjiModel
    
//    init(learningLevel: Level) {
//        self.learningLevel = learningLevel
//        self.curentKanji = stores.kanjistore.getData(learningLevel).first ?? .MOCK_KANJI
//    }
    
    var body: some View {
        VStack {
            
            Group {
                if isFrontSide {
                    FrontSideVIew(kanji: curentKanji)
                } else {
                    BackSideView(kanji: curentKanji)
                }
            }
            .onTapGesture {
                isFrontSide.toggle()
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
    
    func index(number: Int) -> Int {
        var result = self.number
        if currentLearning.count == 1 {
            return result
        }
        if number >= 0 && number <= currentLearning.count {
            result = number
        }
        return result
    }
    
    func changeKanji(index: Int) {
        number = self.index(number: index)
        curentKanji = currentLearning[number]
    }
}

struct LearningCardView_Previews: PreviewProvider {
    static var previews: some View {
        LearningCardView(currentLearning: [.MOCK_KANJI], curentKanji: .MOCK_KANJI)
    }
}
