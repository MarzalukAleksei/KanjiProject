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
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: size.width, height: size.height)
            Text("\(levelTitle.rawValue)")
                .foregroundColor(.white)
                .font(CustomFont.scroll(size: 35))
            Circle()
                .stroke(lineWidth: 5)
                .frame(width: size.width - 20, height: size.height - 20)
                .foregroundColor(.white)
                
        }
        .foregroundColor(color)
    }
}

struct LevelButton_Previews: PreviewProvider {
    static var previews: some View {
        LevelButton(levelTitle: .another, size: CGSize(width: 100, height: 100), color: .black)
    }
}
