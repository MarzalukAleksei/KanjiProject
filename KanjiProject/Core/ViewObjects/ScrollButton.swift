//
//  ScrollButton.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/15.
//

import SwiftUI

struct ScrollButton: View {
    let title: String
    let subtitle: String
    let size: CGSize
    var body: some View {
        ZStack(alignment: .center) {
            Image("Scroll")
                .resizable()
            Text(title.uppercased())
                .font(FontStyle.scroll(size: titleSize()))
        }
        .frame(height: size.height)
    }
    
    func titleSize() -> Double {
        let ratio = size.width / size.height
        let result = size.height / ratio
        return result
    }
    
}

struct ScrollButton_Previews: PreviewProvider {
    static var previews: some View {
        ScrollButton(title: "漢字", subtitle: "Kanji", size: .init(width: 380, height: 200))
    }
}
