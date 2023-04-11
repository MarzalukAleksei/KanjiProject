//
//  ContentView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/02.
//

import SwiftUI

struct MainScreenView: View {
    
    @State var arrat = [KanjiModel]()
    
    var body: some View {
        ZStack {
            BackgroundView(array: arrat)
            ButtonVIew()
        }
        .onAppear() {
            arrat = KanjiMapper().gettingData(entity: FileMapper().transform(data: try! FileManager().loadFile(fileName: "Kanji", fileType: .csv)))
        }
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
    }
}
