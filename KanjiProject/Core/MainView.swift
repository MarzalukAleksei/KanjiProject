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
//            var result = store.kanjiKankenStore.getAll().map { $0.id }
//            var missed: Set<Int> = []
//            for i in result {
//                let numbers = result.filter { $0 == i }
//                if numbers.count > 1 {
//                    missed.insert(i)
//                }
//            }
//            
//            for kan in missed.sorted() {
//                let i = store.kanjiKankenStore.getAll().first(where: { $0.id == kan })
//                print(i?.id, i?.body, i?.nouryokuLevel, i?.kankenLevel)
//            }
            
//            var sameList: [KanjiKankenModel] = []
//            for kanji in store.kanjiKankenStore.getAll() {
//                if kanji.body == kanji.oldKanji {
//                    sameList.append(kanji)
//                }
//            }
//            print(sameList.count)
//            
//            for i in sameList where i.nouryokuLevel == .N1 {
//                print(i.body, i.oldKanji, i.nouryokuLevel)
//            }
////            print(kanji?.nouryokuLevel)
//            
//            let kan = store.kanjiKankenStore.getAll().filter { $0.body == "朗" }
//            print(kan.count)
//            for i in kan {
//                print(i.body, i.nouryokuLevel, i.oldKanji, i.id)
//                print(i.link)
//                print(i.body.unicodeScalars.first?.value, i.oldKanji.unicodeScalars.first?.value)
//                print("+++++++")
//                print(i)
//                print(i.body == "廊")
//            }
//            let kanji朗 = store.kanjiKankenStore.getAll().first(where: { $0.id == 3403 })
//            let uni = "廊".unicodeScalars.first?.value
//            let uni2 = "廊".unicodeScalars.first?.value
//            print(uni)
//            print(uni2)
//            print(uni == uni2)
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
