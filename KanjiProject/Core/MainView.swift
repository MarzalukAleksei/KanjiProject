//
//  MainView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/22.
//

import SwiftUI

enum TabBarElements: String, CaseIterable {
    case kanji = "Кандзи"
    case yojijukugo = "Идиомы"
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
                IdiomView()
                    .tag(TabBarElements.yojijukugo)
                UserListView()
                    .tag(TabBarElements.card)
                SearchView()
                    .tag(TabBarElements.search)
            }
            .padding(.bottom, 0) // поставил 0 вместо 53 так как здесь тернарный оператор не работает
            
            
//            if !tabBarIsHidden {
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
            print("Dictionary - ", store.dictionaryStore.getAll().count)
            print("Kanji - ", store.kanjiStore.getAll().count)
            print("kana - ", store.kanaStore.getAll().count)
            print("giseigo - ", store.giseigo.getAll().count)
            print("KanjiKentei - ", store.kanjiKanken.getAll().count)
//            print(store.kanjiKentei.getAll().randomElement())
            
//            CoreMLManager().getPrediction()
//            CoreDataManager.shared.deleteAllUsersKanjiData(context: viewContext)
            
            
            
//            setJSONFile()
            
        }
    }
    
    func setJSONFile() {
        let refactorStores = RefactoredStores()
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
        JSONManager.methoods.saveJSONToFile(JSONManager.methoods.encodeToJSON(refactorStores.kanjiKenteiStore.getAll()), fileName: .kanjiKanken)
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
        MainView()
            .environmentObject(Store())
            .environmentObject(TabBarState())
    }
}
