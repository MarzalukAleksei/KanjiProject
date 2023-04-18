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
                ZStack {
                    BackgroundView(array: stores.kanjistore.getData())
                    ScrollsView(path: $path, stores: $stores)
                }
                    .tabItem {
                        Label {
                            Text("Main")
                        } icon: {
                            Image(systemName: "pencil")
                        }

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
