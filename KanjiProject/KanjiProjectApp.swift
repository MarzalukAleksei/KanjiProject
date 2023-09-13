//
//  KanjiProjectApp.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/02.
//

import SwiftUI

@main
struct KanjiProjectApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    @ObservedObject var store = Store()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, DataController.shared.container.viewContext)
                .environmentObject(store)
                
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active: break
            case .background:
                background()
            case .inactive: break
            @unknown default:
                break
            }
        }
        
    }
    
    init() {
//        checkFontTitle()
    }
    
    func checkFontTitle() {
        for familyName in UIFont.familyNames {
            print(familyName)
            for name in UIFont.fontNames(forFamilyName: familyName) {
                print("--- \(name)")
            }
        }
    }
    
    func background() {
//        if let data = JSON.methoods.encodeToJSON(store.kanjiStore.getAll()) {
        let data = JSON.methoods.encodeToJSON(store.kanjiStore.getAll())
            JSON.methoods.saveJSONToFile(data, fileName: .kanji)
//        }
    }
}
