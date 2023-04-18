//
//  ContentView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/02.
//

import SwiftUI

struct MainScreenView: View {
    
    @State var stores: Stores
    @State var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            TabView {
                ScrollsView(path: $path, stores: $stores)
                    .tabItem {
                        Label("Main", systemImage: "pencil")
                    }
                SelectLevelView(stores: $stores, path: $path)
                    .tabItem {
                        Label("Level", systemImage: "book")
                    }
            }
            .navigationTitle("Main")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.gray, for: .navigationBar)
        }
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView(stores: .init())
    }
}
