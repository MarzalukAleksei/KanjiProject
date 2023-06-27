//
//  MainTabView.swift
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

struct MainTabView: View {
    @EnvironmentObject var stores: Stores
    @State var currentTab: TabBarElements = .kanji
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {

        ZStack(alignment: .bottom) {
            TabView(selection: $currentTab) {
                SelectLevel()
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
                        TabBarButton(tab: tab, currentTab: $currentTab)
                    Spacer()
                }
            }
            .padding(.top)
            .frame(maxWidth: .infinity)
            .background(Color.gray)
        }
        
    }
}

private struct CustomImage: View {
    var body: some View {
        ZStack {
            
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(Stores())
    }
}
