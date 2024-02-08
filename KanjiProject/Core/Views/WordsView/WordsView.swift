//
//  WordsView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/02/06.
//

import SwiftUI

struct WordsView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var tabBar: TabBarState
    @AppStorage("baseWordLevel") var wordLevel: NouryokuLevel = .N5
    @State var currentLevel: NouryokuLevel = .another
    var body: some View {
        NavigationStack {
            VStack {
                BaseWordsSelectLevelView(currentLevel: $currentLevel)
                Divider()
                NavigationLink("To Learn") {
                    if let word = store.baseWords.get(level: currentLevel).randomElement() {
                        WordLearningView(level: currentLevel, currentWord: word)
                    } else {
                        EmptyView()
                    }
                }
                
                Spacer()
                
                Color.gray.ignoresSafeArea()
                    .modifier(Modifiers.tabBarSize)
            }
            
            .onAppear {
                currentLevel = wordLevel
                tabBar.tabBarIsHidden = false
        }
        }
    }
}

#Preview {
    WordsView()
        .environmentObject(Store())
        .environmentObject(TabBarState())
}
