//
//  SearchNavigationBar.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/09/20.
//

import SwiftUI

struct SearchNavigationBar: View {
    @Binding var text: String
    @Binding var presentDrawView: Bool
    @EnvironmentObject private var tabBarState: TabBarState
    
    var body: some View {
        VStack {
            ZStack {
                Color.black.ignoresSafeArea()
                    .frame(height: ElementSize.customNavigationBarHeight)
                HStack {
                    TextField("Поиск", text: $text, onEditingChanged: { isEditing in
                        tabBarState.tabBarIsHidden = isEditing
                    })
                        .textFieldStyle(.roundedBorder)
                        .padding(.leading, Settings.padding)
                        .padding(.trailing, Settings.paddingBetweenElements)
                        .padding(.bottom, 0)
                    .textInputAutocapitalization(.never)
                    
                    Button {
                        presentDrawView.toggle()
                    } label: {
                        ButtonsImages.pencil
                            .resizable()
                            .frame(width: ElementSize.pencilButtonSize.width, height: ElementSize.pencilButtonSize.height)
                    }
                    .padding(.trailing, Settings.padding)
                    .foregroundStyle(.white)
                }
                    
            }
        }
    }
}

struct SearchNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SearchNavigationBar(text: .constant(""), presentDrawView: .constant(false))
            Spacer()
        }
        .environmentObject(TabBarState())
        
    }
}
