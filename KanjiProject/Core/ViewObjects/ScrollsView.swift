//
//  ScrollsView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/15.
//

import SwiftUI

struct ScrollsView: View {
    @Binding var path: NavigationPath
    @Binding var stores: Stores
    
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
                                path.append(button)
                            }
                    }
                    Spacer()
                }
                .navigationDestination(for: Button.self, destination: { button in
                    SelectLevelView(stores: $stores, path: $path)
                })
                .padding(10)
            }
//            .navigationTitle("q")
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
        ScrollsView(path: .constant(.init()), stores: .constant(.init()))
    }
}
