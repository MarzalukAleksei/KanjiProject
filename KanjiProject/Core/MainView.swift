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
//    case card = "Карточки"
//    case search = "Поиск"
    case settings = "Параметры"
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
//                UserListView()
//                    .tag(TabBarElements.card)
//                SearchView()
//                    .tag(TabBarElements.search)
                SettingsView()
                    .tag(TabBarElements.settings)
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
            let nonChecked = store.baseWordsStore.getAll().filter { $0.thisWordWasChecked == nil }
            
        }
        
    }
    
    func goiSetting() {
        do {
            var n2GoiWords = GoiMapper().gettingData(entity: FileMapper().transform(data: try FileManage().loadFile(fileName: "語彙N2", fileType: .csv)), level: .N2)
            var findedCount = 0
            for word in n2GoiWords {
                var word = word
                if let inDatabase = store.baseWordsStore.getAll().first(where: { $0.body == word.body }) {
                    word.reading = inDatabase.reading
                    word.meaningInRussian = inDatabase.meaningInRussian
                    if let arIndex = n2GoiWords.firstIndex(where: { $0.body == word.body }) {
                        n2GoiWords[arIndex] = word
                        findedCount += 1
                    }
                }
            }
            
            for i in n2GoiWords {
                print(i)
                print("")
            }
            print("AllWords \(n2GoiWords.count), where finded in Database \(findedCount)")
        } catch {
            print(error)
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
