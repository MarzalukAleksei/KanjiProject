//
//  KanjiProjectApp.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/02.
//

import SwiftUI

@main
struct KanjiProjectApp: App {
//    let array: [KanjiModel] = KanjiMapper().gettingData(entity: FileMapper().transform(data: try! FileManager().loadFile(fileName: "Kanji", fileType: .csv)))
    let stores = Stores()
    
    var body: some Scene {
        WindowGroup {
            MainScreenView(stores: stores)
        }
    }
}
