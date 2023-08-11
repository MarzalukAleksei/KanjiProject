//
//  KanjiRow.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/08.
//

import SwiftUI

struct KanjiRow: View {
    let kanji: [KanjiModel]
    let number: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .stroke(lineWidth: 2)
            HStack {
                ZStack {
                    Rectangle()
                        .frame(width: PartsSize.customRowRectangleSize)
                        .clipShape(PartialRoundedRectangle(cornerRadius: 15,
                                                           corners: [.bottomLeft, .topLeft]))
                    HStack(spacing: 1) {
                        Text("問")
                        if number < 10 {
                            Text(" ")
                        }
                        Text("\(number)")
                    }
                    .font(Font.system(size: 37))
                    .foregroundColor(.white)
                }
                VStack(alignment: .leading, spacing: 5) {
                    Spacer()
//                    Text("Title")
//                        .font(.headline)
                    Text("Пройдено \(rightAnswers()) из \(kanji.count)")
                        .font(.subheadline)
                        .opacity(0.5)
                    ProgressIndicatorView(answers: CGFloat(Settings.elementsInRow), rightAnswers: CGFloat(rightAnswers()))
                        .padding(.vertical, 5)
                }
                Spacer()
            }
//            .frame(maxWidth: .infinity)
        }
        .frame(height: PartsSize.customRowRectangleSize)
        .shadow(radius: 2.5, x: 0, y: 5)
        
    }
    
    func rightAnswers() -> Int {
        
        return 0
    }
}

struct KanjiRow_Previews: PreviewProvider {
    static var previews: some View {
        KanjiRow(kanji: [.MOCK_KANJI], number: 1)
//            .padding(20)
            .frame(width: 300, height: 100)
    }
}
