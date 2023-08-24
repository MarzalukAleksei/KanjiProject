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
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, DataController.shared.container.viewContext)
                .environmentObject(Store())
                
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
