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
    @StateObject private var dataController = DataController()
//    @ObservedObject var stores: Stores
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(Stores())
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active: break
            case .background: break
            case .inactive: break
            @unknown default:
                break
            }
        }
        
    }
    
    init() {
//        self.stores = Stores()
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
}
