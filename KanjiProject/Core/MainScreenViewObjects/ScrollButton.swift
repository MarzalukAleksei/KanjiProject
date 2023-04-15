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
            Text("")
                .background {
                    Image("Scroll")
                        .resizable()
                        .frame(width: size.width * 1.16, height: size.height * 2, alignment: .center)
                }
            HStack {
                Text(title)
                    .font(.custom("UNAO-JAPON-pro--new--", size: titleSize()))
                Spacer()
                Text(subtitle.uppercased())
                    .font(.system(size: titleSize() / 3))
            }
            .padding(size.width / 8)
        }
        .frame(width: size.width, height: size.height)
        
    }

    
    func titleSize() -> Double {
        let result = size.height / 2.8
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
