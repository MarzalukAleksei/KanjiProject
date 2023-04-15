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
                .frame(width: size.width, height: size.height, alignment: .center)
            Text(title)
                .font(.custom("UNAO-JAPON-pro--new--", size: titleSize()))
        }
    }
    

    
    func titleSize() -> Double {
        let ratio = size.width / size.height
        let result = size.height / ratio
        return result
    }
    
//    func transformedTitle() -> [String] {
//        return title.map { String($0) }
//    }
    
}

struct ScrollButton_Previews: PreviewProvider {
    static var previews: some View {
        ScrollButton(title: "漢字", subtitle: "Kanji", size: .init(width: 380, height: 200))
    }
}
