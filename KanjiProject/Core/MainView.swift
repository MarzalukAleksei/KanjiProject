//
//  MainView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/22.
//

import SwiftUI

enum TabBarElements: String, CaseIterable {
    case kanji = "Кандзи"
//    case yojijukugo = "Идиомы"
    case words = "Слова"
    case card = "Карточки"
    case search = "Поиск"
}

struct MainView: View {
    
    @State var currentTab: TabBarElements = .kanji
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: []) var kanji: FetchedResults<UsersKanji>
    @EnvironmentObject private var tabBarState: TabBarState
    
    @EnvironmentObject var store: Store
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {

        ZStack(alignment: .bottom) {
            TabView(selection: $currentTab) {
                KanjiView()
                    .tag(TabBarElements.kanji)
//                IdiomView()
//                    .tag(TabBarElements.yojijukugo)
                WordsView()
                    .tag(TabBarElements.words)
                UserListView()
                    .tag(TabBarElements.card)
                SearchView()
                    .tag(TabBarElements.search)
            }
            .padding(.bottom, 0) // поставил 0 вместо 53 так как здесь тернарный оператор не работает
            
            if !tabBarState.tabBarIsHidden {
                HStack {
                    Spacer()
                    ForEach(TabBarElements.allCases, id: \.self) { tab in
                            TabBarButton(tab: tab, currentTab: $currentTab)
                        Spacer()
                    }
                }
                .padding(.top, Settings.padding)
                .frame(maxWidth: .infinity)
                .background(Color.gray)
            }
                
        }
        .onAppear {
            var words: [String] = []
            for word in store.kanjiKankenStore.getAll() where word.nouryokuLevel != nil {
                for example in word.examples {
                    let array = example.value.components(separatedBy: "・")
                    words.append(contentsOf: array)
                }
            }
            print(Set(words).randomElement())
            
//            Task {
////                await Parse().wordsExamples("https://www.weblio.jp/content/容貌")
//                let result = await Parse().wordsExamples("https://www.weblio.jp/content/陸屋根")
//                print(result)
//            
//                
//            }
            
//            Task {
//               await setJSONFile()
//            }
//            clear()
//            jlptLevelSet()
//            setTranslate()
//            print(store.kanjiKankenStore.getAll().filter { $0.nouryokuLevel != nil }.count)
//            removeEng()
//        findCopy()
//            let arr = store.kanjiKankenStore.getAll().filter { $0.body == "社"}
//            for i in arr {
//                print(i.body, i.kankenLevel, i.id, i.link)
//            }
        }
    }
    
    func findCopy() {
        var result: [KanjiKankenModel] = []
        let array = store.kanjiKankenStore.getAll()
        for mainKanji in array {
            for kanji in array {
                if mainKanji.body == kanji.body, mainKanji.id != kanji.id {
                    result.append(mainKanji)
                    result.append(kanji)
                }
            }
        }
        for res in result {
            print(res.body, res.kankenLevel)
        }
    }
    
    func removeEng() {
        let string = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM"
        let kankenArray = store.kanjiKankenStore.getAll().filter { $0.nouryokuLevel != nil }
        for kanji in kankenArray {
            for char in string {
                if let meaningInRus = kanji.meaningInRussion {
                    if meaningInRus.contains(char) || meaningInRus == "—" {
                        var kanji = kanji
                        kanji.meaningInEng = meaningInRus
                        kanji.meaningInRussion = nil
                        store.kanjiKankenStore.update(set: kanji)
                    }
                }
            }
        }
        Task {
            await store.kanjiKankenStore.saveInFileManager()
        }
    }
    
    func setTranslate() {
        let kankenArray = store.kanjiKankenStore.getAll().filter { $0.nouryokuLevel != nil }
        for jlptKanji in store.kanjiStore.getAll() {
            var kanji = kankenArray.first(where: { $0.body == jlptKanji.body })
            kanji?.meaningInRussion = jlptKanji.translate
            if let kanji = kanji {
                store.kanjiKankenStore.update(set: kanji)
            }
            
        }
        Task {
            await store.kanjiKankenStore.saveInFileManager()
        }
    }
    
    func clear() {
        let array = store.kanjiKankenStore.getAll().map { kanji in
            var kanji = kanji
            kanji.meaningInRussion = nil
            kanji.nouryokuLevel = nil
            return kanji
        }
        store.kanjiKankenStore.updateAll(data: array)
    }
    
    func findWords(_ text: String) async -> [(key: String, value: String)] {
        let dictionary = store.dictionaryStore.getAll()
        let filtered = dictionary.filter { $0.body.contains(text) }
        var result: [(key: String, value: String)] = []
        for dictionaryWord in filtered {
            result.append((key: dictionaryWord.body, value: dictionaryWord.reading))
        }
        return result
    }
    
    func setJSONFile() async {
        let refactorStores = await RefactoredStores()
        let arr = refactorStores.kanjiKankenStore.getAll().filter { $0.body == "社"}
        for i in arr {
            print(i.body, i.id, i.link)
        }
//        let rand = refactorStores.kanjiKankenStore.getAll().randomElement()
//        print(rand)
//        refactorStores.kanjiKenteiStore.getAll().count
//        for row in kanjiKentei.enumerated() {
//            print(row.element.body, "--->", row.element.examples, row.element.kenteiLevel, row.offset, "OLD ---> \(row.element.oldKanji)")
//            print("")
//        }
//        JSON.methoods.saveJSONToFile(data: JSON.methoods.encodeToJSON(kanji: refactorStores.kanjiStore.getAll()), fileName: .kanji)
//        JSON.methoods.saveJSONToFile(data: JSON.methoods.encodeToJSON(dictionary: refactorStores.dictionaryStore.getAll()), fileName: .dictionary)
//        JSON.methoods.saveJSONToFile(JSON.methoods.encodeToJSON(refactorStores.yojijukugoStore.getAll()), fileName: .yojijukugo)
//        print(refactorStores.giseigoStore.getAll().randomElement())
//    JSONManager.methoods.saveJSONToFile(JSONManager.methoods.encodeToJSON(refactorStores.giseigoStore.getAll()), fileName: .giseigo)
//        JSONManager.methoods.saveJSONToFile(JSONManager.methoods.encodeToJSON(refactorStores.kanjiKankenStore.getAll()), fileName: .kanjiKanken)
        
//    JSONManager.methoods.saveJSONToFile(JSONManager.methoods.encodeToJSON(refactorStores.wordsStore.getAll()), fileName: .baseWords)
        
//        JSONManager.manager.saveJSONToFile(JSONManager.manager.encodeToJSON(refactorStores.bushuStore.getAll()), fileName: .bushu)
    }
    
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(Store())
            .environmentObject(TabBarState())
    }
}
