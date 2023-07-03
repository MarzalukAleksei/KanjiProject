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
    @State var currentTab: TabBarElements = .dictionary
//    @FetchRequest(sortDescriptors: []) private var kanji: FetchedResults<Kanji>
//    @FetchRequest(sortDescriptors: []) private var user: FetchedResults<UserFaivorite>
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(entity: Kanji.entity(),
                  sortDescriptors: []) var kanji: FetchedResults<Kanji>
    @FetchRequest(entity: DictionaryCoreData.entity(),
                  sortDescriptors: []) var dictionary: FetchedResults<DictionaryCoreData>
    
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
//                DictionaryView()
//                    .tag(TabBarElements.dictionary)
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
        .onAppear {
//            checkCoreData()
            if kanji.isEmpty {
                print("Start Loading File")
                setCoreDataKanji()
                print("End Loading File")
            } else {
                print("CoreData have \(kanji.count) Elements")
                print("Store have \(Stores().kanjistore.getAll().count) Elements")
            }
            
            guard let kanji = kanji.randomElement(),
                  let body = kanji.body,
                  let kun = kanji.kun,
                  let on = kanji.on else { return }
            
            print(body, kun, on)
            print(stores.dictionaryStore.getAll().count)
            print(stores.dictionaryStore.getAll().randomElement())
            
//            DataController.shared.deleteAllKanjiData(context: viewContext)
            
        }
    }
    
    func checkCoreData() {
        if kanji.isEmpty {
            print("Start Loading File")
            setCoreDataKanji()
            print("End Loading File")
        } else {
            print("CoreData have \(kanji.count) Elements")
            print("Store have \(stores.kanjistore.getAll().count) Elements")
        }
        
//        if dictionary.isEmpty {
//            setCoreDataDictionary()
//        } else {
//            print("CoreData have \(dictionary.count) Elements")
//            print("Store have \(stores.dictionaryStore.getAll().count) Elements")
//        }
    }
    
    func setCoreDataDictionary() {
        for word in stores.dictionaryStore.getAll().enumerated() {
            
        }
    }
    
    func setCoreDataKanji() {
        let stores = Stores()
        
        for storedElement in stores.kanjistore.getAll().enumerated() {
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
            .environmentObject(Stores())
    }
}
