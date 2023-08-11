//
//  LearningCell.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/11.
//

import SwiftUI

struct LearningCell: View {
    let kanji: KanjiModel
    
    var body: some View {
        
        VStack {
            ForEach(kanji.examples, id: \.self) { example in
                Text(example)
            }
        }
    }
}

struct LearningCell_Previews: PreviewProvider {
    static var previews: some View {
        LearningCell(kanji: .MOCK_KANJI)
    }
}
