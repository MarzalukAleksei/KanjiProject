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
                    .frame(width: Settings.tabBarButtonImageSize.width,
                           height: Settings.tabBarButtonImageSize.height)
//                CustomImage()
                if tab == currentTab {
                    Text(tab.rawValue)
                        .font(CustomFont.scroll(size: 25))
                        .lineLimit(1)
                }
            }
        }
        .padding(.vertical, Settings.padding / 2)
        .padding(.horizontal, 12.5)
        .background(Color.white)
        .clipShape(Capsule())
        .foregroundColor(.black)

    }
    
    func image(tab: TabBarElements, currentTab: TabBarElements) -> Image {
        switch tab {
        case .kanji:
            return ButtonsImages.mainScreen
//        case .yojijukugo:
        case .words:
            return ButtonsImages.brain
        case .card:
            return ButtonsImages.list
        case .search:
//            return tab == currentTab ? ButtonsImages.openBook : ButtonsImages.closeBook
            return ButtonsImages.magnifyingglass
        }
    }
}

struct TabBarButton_Preview: PreviewProvider {
    static var previews: some View {
        TabBarButton(tab: .card, currentTab: .constant(.card))
            .background(Color.red)
    }
}
