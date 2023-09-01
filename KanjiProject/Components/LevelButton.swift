//
//  LevelButton.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/08.
//

import SwiftUI

struct LevelButton: View {
    let levelTitle: Level
    let kanjiArray: [KanjiModel]
    let size: CGSize
    let color: Color
    let colors: [Color] = [.red, .green, .white]
    var values: [Double] {
        let inArray = Double(kanjiArray.count)
        let red = Double(kanjiArray.filter { $0.lastAnswerRight == false }.count)
        let green = Double(kanjiArray.filter { $0.lastAnswerRight == true }.count)
        let white = Double(kanjiArray.filter { $0.lastAnswerRight == nil }.count)
        let redValue = red / inArray
        let greenValue = green / inArray
        let whiteValue = white / inArray
        return [redValue, greenValue, whiteValue]
    }
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: size.width, height: size.height)
            Text("\(levelTitle.rawValue)")
                .foregroundColor(.white)
                .font(CustomFont.scroll(size: 35))
            
            ForEach(0..<3) { index in
                Circle()
                    .trim(from: index == 0 ? 0 : values[0..<index].reduce(0, +),
                          to: values[0...index].reduce(0, +))
                    .stroke(lineWidth: 5)
                    .frame(width: size.width - 20, height: size.height - 20)
                    .foregroundColor(colors[index])
                    .rotationEffect(.degrees(-90))
            }
        }
        .foregroundColor(color)
    }
}

struct LevelButton_Previews: PreviewProvider {
    static var previews: some View {
        LevelButton(levelTitle: .another, kanjiArray: [.MOCK_KANJI, .MOCK_KANJI], size: CGSize(width: 100, height: 100), color: .black)
    }
}
