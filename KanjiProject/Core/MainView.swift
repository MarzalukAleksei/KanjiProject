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
//        .task {
//            await setJSONFile()
//        }
        .onAppear {
//            Task {
//                await setTranslateTask()
//            }
//            CoreMLManager().getPrediction()
//            CoreDataManager.shared.deleteAllUsersKanjiData(context: viewContext)
            
//            Task {
//                await setJSONFile()
//            }
//            Task {
//                await saveImage(array:store.kanjiKanken.get(level: .級10))
//            }
//            for i in store.kanjiStore.getData(.N5) {
//                print(i.lastAnswerRight)
//            }
//            var data = store.baseWords.getAll()
//            data = data.map { word in
//                var word = word
//                word.id = UUID()
//                return word
//            }
//            store.baseWords.updateAll(data: data)
            print(store.baseWords.get(level: .N3).first(where: { $0.body == "此の"}))
            print(store.baseWords.getAll().randomElement())
//                NihongoMapper().gettingData(entity: FileMapper().transform(data: try FileManage().loadFile(fileName: "日本語", fileType: .txt)))
//            } catch {
//                
//            }
        }
    }
    
    
//    func setTranslateTask() async {
//        let kanjiKankenArray = await withTaskGroup(of: [(key: String, value: String)].self, returning: [KanjiKankenModel].self) { taskGroup in
//            for word in store.kanjiKanken.getAll() {
//                taskGroup.addTask {
//                    await findWords(word.body)
//                }
//            }
//            var results: [KanjiKankenModel] = store.kanjiKanken.getAll()
//            
//            for await result in taskGroup {
//                
//            }
//            return results
//        }
//        
//    }
    
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
    }
    
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(Store())
            .environmentObject(TabBarState())
    }
}
