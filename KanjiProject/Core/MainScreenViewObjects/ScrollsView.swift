//
//  ScrollsView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/15.
//

import SwiftUI

struct ScrollsView: View {
    
    let buttons = [
        Button(title: "漢字", subtitle: "kanji"),
        Button(title: "平仮名", subtitle: "hiragana"),
        Button(title: "片仮名", subtitle: "katakana"),
        Button(title: "暗記カード", subtitle: "Anki Cards")
    ]
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
//                Color.cyan
                VStack(spacing: 10) {
                    ForEach(buttons, id: \.self) { button in
                        ScrollButton(title: button.title, subtitle: button.subtitle, size: buttonsSize(geometry))
                            .onTapGesture {
                                print(button)
                            }
                    }
                    Spacer()
                }
                .padding(10)
            }
        }
    }
    
    func buttonsSize(_ geometry: GeometryProxy) -> CGSize {
        let width = geometry.size.width - 20
        let height = geometry.size.height / CGFloat(buttons.count + 2)
        return CGSize(width: width, height: height)
    }
    
    struct Button: Hashable {
        let title: String
        let subtitle: String
    }
}

struct ScrollsView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollsView()
    }
}
