//
//  JoinexTextView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/27.
//

import SwiftUI

struct JoinedTextView: View {
    @EnvironmentObject private var store: Store
    let text: String
    private var textAndLinks: [(isText: Bool, text: String)] {
        text.textAndLinks()
    }
    
    var body: some View {
        
        if textAndLinks.isEmpty {
            Text(text)
                .font(.system(size: 13))
        } else {
            links(textAndLinks)
        }
    }
    
    private func links(_ textAndLinks: [(isText: Bool, text: String)]) -> some View {
        var result = Text("")
        
        for value in textAndLinks {
            if value.isText {
                result = result + Text(value.text)
            } else {
                let dictionaryWord = store.dictionaryStore.getAll().first { $0.number == value.text } ?? .MOCK_DICTIONARY
                result = result +
                Text("\(dictionaryWord.body) ")
                    .bold()
            }
        }
        
        return result
    }
}

struct JoinexTextView_Previews: PreviewProvider {
    static var previews: some View {
        JoinedTextView(text: "Text")
            .environmentObject(Store())
    }
}
