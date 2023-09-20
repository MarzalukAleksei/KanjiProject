//
//  WordDetailView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/09/20.
//

import SwiftUI

struct SearchWordDetailView: View {
    let word: DictionaryModel
    var body: some View {
        VStack {
            Text(word.body)
            Text(word.reading)
            ForEach(word.examples, id: \.self) { row in
                Text(row)
            }
        }
    }
}

struct SearchWordDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SearchWordDetailView(word: .MOCK_DICTIONARY)
    }
}
