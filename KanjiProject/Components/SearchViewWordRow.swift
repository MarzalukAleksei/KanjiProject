//
//  SearchViewWordRow.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/09/20.
//

import SwiftUI

struct SearchViewWordRow: View {
    let word: DictionaryModel
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Settings.cornerRadius)
                .stroke(lineWidth: 2)
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(word.reading)
                        .font(.footnote)
                        .opacity(Settings.opacity)
                    Text(word.body)
                        .fontWeight(.bold)
                    Rectangle()
                        .frame(height: 1)
                        .opacity(Settings.opacity)
//                    Text(DictionaryModel.getFirstExample(word: word))
                    JoinedTextView(text: DictionaryModel.getFirstExample(word: word))
                }
                .padding(Settings.paddingBetweenElements)
            }
            
        }
        .padding(.horizontal, Settings.padding)
    }
}

struct SearchViewWordRow_Previews: PreviewProvider {
    static var previews: some View {
        SearchViewWordRow(word: .MOCK_DICTIONARY)
            .frame(maxWidth: .infinity, maxHeight: 100)
    }
}
