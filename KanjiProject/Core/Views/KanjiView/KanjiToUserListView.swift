//
//  KanjiToUserListView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/25.
//

import SwiftUI

struct KanjiToUserListView: View {
    @Environment(\.dismiss) var dismiss
    
    let kanji: KanjiModel
    
    var body: some View {
        VStack {
            Text(kanji.body)
                .font(.largeTitle)
            
            ScrollView {
                ForEach(kanji.examples, id: \.self) { examples in
                    Text(examples)
                }
            }
            
            Spacer()
            
            HStack(spacing: Settings.paddingBetweenElements) {
                
                Button {
                    dismiss()
                } label: {
                    Text("Не добавлять")
                        .modifier(Modifiers.userButton)
                    
                }
                
                Button {
                    
                    dismiss()
                } label: {
                    Text("В Мой Список")
                        .modifier(Modifiers.userButton)
                }
            }
            
        }
        .foregroundColor(.black)
        .padding(Settings.padding)
    }
}

struct KanjiToUserListView_Previews: PreviewProvider {
    static var previews: some View {
        KanjiToUserListView(kanji: .MOCK_KANJI)
    }
}
