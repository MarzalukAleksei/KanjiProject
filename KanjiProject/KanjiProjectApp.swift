//
//  KanjiProjectApp.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/02.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct KanjiProjectApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    @ObservedObject var store = Store()
    @ObservedObject var tabBarState = TabBarState()
    @ObservedObject var globalChanging = GlobalChanging()
    @ObservedObject var userSettings = UserSettings()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @ObservedObject var loading = DataLoading()
    
    @AppStorage("User Settings") private var settingsDatabase: Data?
    
    var body: some Scene {
        WindowGroup {
            if loading.complete {
                MainView()
                    .preferredColorScheme(.light)
                    .statusBarHidden()
                    .environment(\.managedObjectContext, CoreDataManager.shared.container.viewContext)
                    .environmentObject(store)
                    .environmentObject(tabBarState)
                    .environmentObject(globalChanging)
                    .environmentObject(userSettings)
                //            DrawView(size: CGSize(width: 300, height: 300))
            } else {
                LoadingView()
                    .onAppear {
                        loading.load()
                    }
            }
                
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active: break
            case .background:
//                background()
                Task {
                    await store.kanjiKankenStore.saveInFileManager()
                }
            case .inactive: break
            @unknown default:
                break
            }
        }
        .onChange(of: loading.complete) { res in
            if res {
                loading.data { result in
                    switch result {
                    case .success(let store):
                        self.store.updateAll(store: store)
                    case .failure(_):
                        break
                    }
                }
            }
        }
    }
    
    init() {
        userSettings = decodeUserSettings()
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
        let data = JSONManager.manager.encodeToJSON(store.kanjiStore.getAll())
            JSONManager.manager.saveJSONToFile(data, fileName: .kanji)
//        }
    }
    
    func decodeUserSettings() -> UserSettings {
        guard let data = settingsDatabase,
              let uSet: UserSettings = JSONManager.manager.decodeToModel(data) else { return UserSettings() }
        return uSet
    }
}
