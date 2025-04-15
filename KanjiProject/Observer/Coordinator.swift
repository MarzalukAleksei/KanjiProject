//
//  Coordinator.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2025/04/13.
//

import SwiftUI

enum Page: Hashable {
    case kanjiView
    case settingsView
    case wordView
    case learnView
    case test
    case checkWordsView
}

class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    func push(page: Page) {
        path.append(page)
    }
    
    @ViewBuilder
    func build(page: Page) -> some View {
        switch page {
        case .kanjiView:
            KanjiView()
        case .settingsView:
            SettingsView()
        case .wordView:
            WordsView()
        case .learnView:
            LearnWordView()
        case .test:
            TestView()
        case .checkWordsView:
            CheckWordsView()
        }
    }
}

struct TestView: View {
    var body: some View {
         Text("TestView")
    }
}
