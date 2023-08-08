//
//  LevelButton.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/08.
//

import SwiftUI

struct LevelButton: View {
    let levelTitle: Level
    let size: CGSize
    let color: Color
    let colors: [Color] = [.red, .green, .white]
    let values: [Double] = [0.3, 0.2, 0.5]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: size.width, height: size.height)
            Text("\(levelTitle.rawValue)")
                .foregroundColor(.white)
                .font(CustomFont.scroll(size: 35))
//            ForEach(values, id: \.self) { index in
            ForEach(0..<values.count) { index in
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
        LevelButton(levelTitle: .another, size: CGSize(width: 100, height: 100), color: .black)
    }
}
