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
    
    @State var currentTab: TabBarElements = .kanji
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
                KanjiView()
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
                print("Kanji is Empty")
            }
            if dictionary.isEmpty {
                print("Dictionary is Empty")
            }
            
//            DataController.shared.deleteAllKanjiData(context: viewContext)
//            DataController.shared.deleteAllDictionaryData(context: viewContext)
            
        }
    }
    
    func checkCoreData() {
        if kanji.isEmpty {
            print("Start Loading File")
//            setCoreDataKanji()
            print("End Loading File")
        } else {
            print("CoreData have \(kanji.count) Elements")
//            print("Store have \(stores.kanjistore.getAll().count) Elements")
        }
        
        if dictionary.isEmpty {
//            setCoreDataDictionary()
        } else {
            print("CoreData have \(dictionary.count) Elements")
//            print("Store have \(Stores().dictionaryStore.getAll().count) Elements")
        }
    }
    
//    func setCoreDataDictionary() {
//        let stores = Stores()
//
//        for word in stores.dictionaryStore.getAll().enumerated() {
//            DataController.shared.add(dictionary: word.element, context: viewContext)
//            print("Now \(word.offset), Remain \(stores.dictionaryStore.getAll().count - word.offset)")
//        }
//    }
//
//    func setCoreDataKanji() {
//        let stores = Stores()
//
//        for storedElement in stores.kanjistore.getAll().enumerated() {
////            DataController().add(kanji: storedElement.element, context: viewContext)
//            DataController.shared.add(kanji: storedElement.element, context: viewContext)
//            print("Now \(storedElement.offset)")
//        }
//    }
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
//            .environmentObject(Stores())
    }
}
