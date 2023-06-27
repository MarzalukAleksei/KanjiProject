//
//  TabBarButton.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/06/22.
//

import SwiftUI

struct TabBarButton: View {
    @State var tab: TabBarElements
    @Binding var currentTab: TabBarElements
    
    var body: some View {
        ZStack {
            Button {
                withAnimation(.spring()) {
                    currentTab = tab
                }
            } label: {
                image(tab: tab, currentTab: currentTab)
                    .resizable()
                    .frame(width: 20, height: 25)
//                CustomImage()
                if tab == currentTab {
                    Text(tab.rawValue)
                        .font(FontStyle.scroll(size: 25))
                        .lineLimit(1)
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12.5)
        .background(Color.white)
        .clipShape(Capsule())
        .foregroundColor(.black)

    }
    
    func image(tab: TabBarElements, currentTab: TabBarElements) -> Image {
        switch tab {
        case .kanji:
            return ButtonsImage.mainScreen
        case .yojijukugo:
            return ButtonsImage.brain
        case .card:
            return ButtonsImage.card
        case .dictionary:
            return tab == currentTab ? ButtonsImage.openBook : ButtonsImage.closeBook
        }
    }
}

struct TabBarButton_Preview: PreviewProvider {
    static var previews: some View {
        TabBarButton(tab: .card, currentTab: .constant(.card))
    }
}
