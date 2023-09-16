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
    let cellTitle: String
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
                            Text(cellTitle)
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
                        
                        Spacer()
                        
                        ProgressIndicatorLine(answers: CGFloat(kanji.count), rightAnswers: CGFloat(rightAnswers()))
                            .padding(.vertical, 5)
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
        
        return kanji.filter { $0.lastAnswerRight == true }.count
    }
}

struct KanjiRow_Previews: PreviewProvider {
    static var previews: some View {
        KanjiRow(kanji: [.MOCK_KANJI], number: 1, cellTitle: "問", current: true)
            .frame(width: 300, height: 100)
        KanjiRow(kanji: [.MOCK_KANJI], number: 1, cellTitle: "問", current: false)
            .frame(width: 300, height: 100)
    }
}
