//
//  ContentView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/02.
//

import SwiftUI

struct MainScreenView: View {
    
    let arrat = [KanjiModel]()
    
    var body: some View {
        ZStack {
            BackgroundView(level: .All)
            
        }
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
    }
}
