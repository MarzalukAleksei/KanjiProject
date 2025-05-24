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
    case test(num: Int)
    case checkWordsView
    case kanjiLearningView(kankenIsSelected: Bool, jlpt: NouryokuLevel, kanken: KankenLevel)
    case searchView
    case deteilWord(word: DictionaryModel)
    case editWord(word: WordModel)
}

class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var showCover = false
    @Published var cover: Page?
    
    func push(page: Page) {
        path.append(page)
    }
    
    func cover(by page: Page) {
        cover = page
        showCover = true
    }
    
    func closeAll(exept numberOfView: Int = 0) {
        let inStack = path.count
        path.removeLast(inStack - numberOfView)
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
        case .test(let num):
            TestView(id: num)
        case .checkWordsView:
            CheckWordsView()
        case .kanjiLearningView(let kankenIsSelected, let jlpt, let kanken):
            KanjiLearningView(selectedKanken: kankenIsSelected, nouryokuLevel: jlpt, kankenLevel: kanken)
        case .searchView:
            SearchView()
        case .deteilWord(let word):
            WordDetailView(word: word)
        case .editWord(let word):
            EditWordView(word: word)
        }
    }
}

struct TestView: View {
    @EnvironmentObject var coordinator: Coordinator
    let id: Int
    init(id: Int = 1) {
        self.id = id
    }
    var body: some View {
        VStack {
            Text("TestView ID - \(id)")
            Button("Go next") {
                coordinator.push(page: .test(num: id + 1))
            }
            Button("Close All") {
                coordinator.closeAll()
            }
        }
    }
}
