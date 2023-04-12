//
//  KanjiProjectApp.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/02.
//

import SwiftUI
//import UIKit
//
//class UIAppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//
//        return true
//    }
//}

@main
struct KanjiProjectApp: App {
    
//    @UIApplicationDelegateAdaptor(UIAppDelegate.self) var appDelegate
    
    let stores = Stores()
    
    var body: some Scene {
        WindowGroup {
            MainScreenView(stores: stores)
        }
    }
}
