//
//  KanjiRow.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/08.
//

import SwiftUI

struct KanjiRow: View {
    let kanji: [Any]
    let number: Int
    let current: Bool
    
    var body: some View {
        HStack(spacing: -10) {
            if current {
                Rectangle()
                    .frame(width: 20, height: ElementSize.customRowRectangleSize + 2)
//                    .foregroundColor(.gra)
                    .opacity(Settings.opacity)
                    .clipShape(PartialRoundedRectangle(cornerRadius: 15, corners: [.topLeft, .bottomLeft]))
            }
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(lineWidth: 2)
                HStack {
                    ZStack {
                        Rectangle()
                            .frame(width: ElementSize.customRowRectangleSize)
                            .clipShape(PartialRoundedRectangle(cornerRadius: 15,
                                                               corners: [.bottomLeft, .topLeft]))
                        HStack(spacing: 1) {
                            if number < 10 {
                                Text("")
                            }
                            Text("\(number)")
                        }
                        .font(Font.system(size: 37))
                        .foregroundColor(.white)
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Пройдено \(rightAnswers()) из \(kanji.count)")
                            .font(.subheadline)
                            .opacity(0.5)
                            .padding(.top, Settings.paddingBetweenElements + Settings.paddingBetweenText)
                        
                        Spacer()
                        
                        ProgressIndicatorBar(answers: CGFloat(kanji.count), rightAnswers: CGFloat(rightAnswers()))
                            .padding(.bottom, Settings.paddingBetweenElements + Settings.paddingBetweenText)
                    }
                    Spacer()
                }
    //            .frame(maxWidth: .infinity)
            }
            .frame(height: ElementSize.customRowRectangleSize)
            .shadow(radius: 2.5, x: 0, y: 5)
        }
        
    }
    
    func rightAnswers() -> Int {
        switch kanji {
        case is [KanjiModel]: 
            guard let kanji = kanji as? [KanjiModel] else { return 0 }
            return kanji.filter { $0.lastAnswer() == true }.count
        case is [KanjiKankenModel]:
            guard let kanji = kanji as? [KanjiKankenModel] else { return 0 }
            return kanji.filter { $0.lastAnswer() == true }.count
        case _: break
        }
        return 0
    }
}

struct KanjiRow_Previews: PreviewProvider {
    static var previews: some View {
        KanjiRow(kanji: [KanjiModel.MOCK_KANJI], number: 1, current: true)
            .frame(width: 300, height: 100)
        KanjiRow(kanji: [KanjiModel.MOCK_KANJI], number: 1, current: false)
            .frame(width: 300, height: 100)
    }
}
