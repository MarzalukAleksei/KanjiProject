//
//  NavigationView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/11.
//

import SwiftUI

struct NavigationView: View {
    @State var navigationPath = NavigationPath()
    var body: some View {
        NavigationStack(path: $navigationPath) {
            Button("Do") {
                print("SOME")
            }
        }
        
    }
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView()
    }
}
