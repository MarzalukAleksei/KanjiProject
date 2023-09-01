//
//  MainTabView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/22.
//

import SwiftUI

enum TabBarElements: String, CaseIterable {
    case kanji = "Кандзи"
    case yojijukugo = "Идиомы"
    case card = "Карточки"
    case dictionary = "Словарь"
}

struct MainTabView: View {
    
    @State var currentTab: TabBarElements = .kanji
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(entity: Kanji.entity(),
                  sortDescriptors: []) var kanji: FetchedResults<Kanji>
    @FetchRequest(entity: DictionaryCoreData.entity(),
                  sortDescriptors: []) var dictionary: FetchedResults<DictionaryCoreData>
    @State var tabBarIsHidden = false
    
    @EnvironmentObject var store: Store
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {

        ZStack(alignment: .bottom) {
            TabView(selection: $currentTab) {
                KanjiView(tabBarIsHidden: $tabBarIsHidden)
                    .tag(TabBarElements.kanji)
                IdiomView()
                    .tag(TabBarElements.yojijukugo)
                Text("card")
                    .tag(TabBarElements.card)
//                DictionaryView()
//                    .tag(TabBarElements.dictionary)
            }
            .padding(.bottom, 0) // поставил 0 вместо 53 так как здесь тернарный оператор не работает
            
            
            if !tabBarIsHidden {
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
            
//            print(store.dictionaryStore.getAll().randomElement()?.translate)
//            setJSONFile()
            
//            DictionaryModel.dictionary = DictionaryModel.transform(dictionary)
//            print(DictionaryModel.dictionary.count)
//            checkCoreData()
            
//            if kanji.isEmpty {
//                print("Kanji is Empty")
//            }
//            if dictionary.isEmpty {
//                print("Dictionary is Empty")
//            }
//            
//            DataController.shared.deleteAllKanjiData(context: viewContext)
//            DataController.shared.deleteAllDictionaryData(context: viewContext)
            
        }
    }
    
    func setJSONFile() {
        let refactorStores = RefactoredStores()
        JSON.methoods.saveJSONToFile(data: JSON.methoods.encodeToJSON(kanji: refactorStores.kanjiStore.getAll()), fileName: .kanji)
        JSON.methoods.saveJSONToFile(data: JSON.methoods.encodeToJSON(dictionary: refactorStores.dictionaryStore.getAll()), fileName: .dictionary)
    }
    
    func checkCoreData() {
        if kanji.isEmpty {
            print("Start Loading File")
            setCoreDataKanji()
            print("End Loading File")
        } else {
            print("CoreData have \(kanji.count) Elements")
//            print("Store have \(stores.kanjistore.getAll().count) Elements")
        }
        
        if dictionary.isEmpty {
            setCoreDataDictionary()
        } else {
            print("CoreData have \(dictionary.count) Elements")
//            print("Store have \(Stores().dictionaryStore.getAll().count) Elements")
        }
    }
    
    func setCoreDataDictionary() {
        let stores = RefactoredStores()

        for word in stores.dictionaryStore.getAll().enumerated() {
            DataController.shared.add(dictionary: word.element, context: viewContext)
            print("Now \(word.offset), Remain \(stores.dictionaryStore.getAll().count - word.offset)")
        }
    }

    func setCoreDataKanji() {
        let stores = RefactoredStores()

        for storedElement in stores.kanjiStore.getAll().enumerated() {
//            DataController().add(kanji: storedElement.element, context: viewContext)
            DataController.shared.add(kanji: storedElement.element, context: viewContext)
            print("Now \(storedElement.offset)")
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
            .environmentObject(Store())
    }
}
