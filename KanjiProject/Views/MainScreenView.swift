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
            GeometryReader { geometry in
                ZStack {
                    BackgroundView(size: geometry.size, array: stores.kanjistore.getData())
                    ButtonVIew()
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
