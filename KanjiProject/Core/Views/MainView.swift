//
//  ContentView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/02.
//

import SwiftUI

struct MainView: View {
    
    @State var stores: Stores
    @State var path = NavigationPath()
    
    var body: some View {
        TabView {
            
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(stores: .init())
    }
}
