//
//  MainView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/22.
//

import SwiftUI

enum TabBarElements: String, CaseIterable {
    case kanji
    case yojijukugo = "Idioms"
    case card
    case dictionary
}

struct MainView: View {
    @EnvironmentObject var stores: Stores
    @State var currentTab: TabBarElements = .dictionary
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {

        ZStack(alignment: .bottom) {
            TabView(selection: $currentTab) {
                Text("Kanji")
                    .tag(TabBarElements.kanji)
                Text("Yojijukugo")
                    .tag(TabBarElements.yojijukugo)
                Text("card")
                    .tag(TabBarElements.card)
                DictionaryView()
                    .tag(TabBarElements.dictionary)
            }
            .padding(.bottom, 50)
            HStack {
                Spacer()
                ForEach(TabBarElements.allCases, id: \.self) { tab in
                        TabButton(tab: tab, currentTab: $currentTab)
                    Spacer()
                }
            }
            .padding(.top)
            .frame(maxWidth: .infinity)
            .background(Color.gray)
        }
        
    }
}

private struct TabButton: View {
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
                        .font(Font.scroll(size: 25))
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
            return Image.mainScreen
        case .yojijukugo:
            return Image.brain
        case .card:
            return Image.card
        case .dictionary:
            return tab == currentTab ? Image.openBook : Image.closeBook
        }
    }
}

private struct CustomImage: View {
    var body: some View {
        ZStack {
            
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(Stores())
    }
}
