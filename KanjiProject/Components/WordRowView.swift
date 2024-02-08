//
//  WordDetailRowView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/24.
//

import SwiftUI

struct WordRowView: View {
    let kanji: KanjiModel
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Settings.dinamicResaiseblePartsCornerRadius)
                .stroke(lineWidth: 2)
            HStack {
                Text(kanji.body)
                    .font(.system(size: 28))
                
                HStack(alignment: .top) {
                    VStack {
                        Text("訓:")
                        Spacer()
                    }
                    VStack(alignment: .leading) {
                        ForEach(separate(string: kanji.kun), id: \.self) { row in
                            Text(row)
                        }
                    }
                }
                Spacer()
                Rectangle()
                    .frame(width: 1)
                    .opacity(Settings.opacity)
                
                HStack(alignment: .top) {
                    VStack {
                        Text("音:")
                        Spacer()
                    }
                    VStack(alignment: .leading) {
                        ForEach(separate(string: kanji.on), id: \.self) { row in
                            Text(row)
                        }
                    }
                    HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            Text("N \(kanji.level.rawValue)")
                            Spacer()
                        }
                    }
                }
//                Spacer()
            }
            .padding(Settings.paddingBetweenElements)
        }
    }
    
    func separate(string: String) -> [String] {
        return string.components(separatedBy: "・")
    }
}

struct WordRowView_Previews: PreviewProvider {
    static var previews: some View {
        WordRowView(kanji: .MOCK_KANJI)
            .frame(maxWidth: .infinity, maxHeight: 100)
            .padding(20)
    }
}
