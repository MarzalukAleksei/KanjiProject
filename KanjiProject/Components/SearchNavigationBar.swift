//
//  SearchNavigationBar.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/09/20.
//

import SwiftUI

struct SearchNavigationBar: View {
    @Binding var text: String
    @EnvironmentObject private var tabBarState: TabBarState
    
    var body: some View {
        VStack {
            ZStack {
                Color.black.ignoresSafeArea()
                    .frame(height: ElementSize.customNavigationBarHeight)
                TextField("Поиск", text: $text, onEditingChanged: { isEditing in
                    tabBarState.tabBarIsHidden = isEditing
                })
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, Settings.padding)
                    .padding(.bottom, 0)
                    .textInputAutocapitalization(.never)
                    
            }
        }
    }
}

struct SearchNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SearchNavigationBar(text: .constant(""))
            Spacer()
        }
        .environmentObject(TabBarState())
        
    }
}
