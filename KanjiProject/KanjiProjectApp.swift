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
    @State private var listLoaded = false
    
    var body: some Scene {
        WindowGroup {
            if allLoaded() {
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
                        readFile(completion: { listLoaded = $0 })
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
    
    func allLoaded() -> Bool {
        [loading.complete, listLoaded].allSatisfy { $0 }
    }
    
    func readFile(completion: @escaping (Bool) -> Void) {
        Task {
            let userStore = await RefactoredStores().usersWordsStore
            
            for word in userStore.getAll() {
                if store.baseWordsStore.getAll().contains(where: { $0.body == word.body }) {
                    var indexes: [Int] = []
                    for (index, word2) in store.baseWordsStore.getAll().enumerated() where word2.body == word.body {
                        indexes.append(index)
                    }
                    indexes.forEach { index in
                        var word = store.baseWordsStore.getAll()[index]
                        word.addInList()
                        store.baseWordsStore.update(set: word)
                    }
                } else {
                    var array = store.usersWordsStore.getAll()
                    if !array.contains(where: { $0.body == word.body }) {
                        var word = word
                        word.addInList()
                        array.append(word)
                        store.usersWordsStore.updateAll(data: array)
                        print("New word \(word.body), \(word.reading), \(word.meaningInRussian)")
                    }
                }
            }
            completion(true)
        }
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
