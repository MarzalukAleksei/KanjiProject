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
//    @EnvironmentObject var stores: Stores
    @State var currentTab: TabBarElements = .kanji
    @FetchRequest(sortDescriptors: []) private var kanji: FetchedResults<Kanji>
//    @FetchRequest(sortDescriptors: []) private var user: FetchedResults<UserFaivorite>
    @Environment(\.managedObjectContext) var viewContext
//    @FetchRequest(entity: Kanji.entity(), sortDescriptors: []) var kanji: FetchedResults<Kanji>
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    func setCoreData() {
        let store = Stores()
        
        for storedElement in store.kanjistore.getAll().enumerated() {
            DataController().add(kanji: storedElement.element, context: viewContext)
            print("Now \(storedElement.offset)")
        }
    }
    
    var body: some View {

        ZStack(alignment: .bottom) {
            TabView(selection: $currentTab) {
                SelectLevel()
//                    .onTapGesture {
//                        if kanji.isEmpty {
//                            print("Start Loading File")
//                //            setCoreData()
//                            print("End Loading File")
//                        } else {
//                            print("CoreData have \(kanji.count) Elements")
//                        }
//                    }
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
            if kanji.isEmpty {
                print("Start Loading File")
                setCoreData()
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
            
//                DataController().deleteAllKanjiData(context: viewContext)
            
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
