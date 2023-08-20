//
//  LearningCell.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/11.
//

import SwiftUI

struct LearningCell: View {
    enum Property {
        case kun, on, examples, translate
    }
    
    let title: String
    let kanji: KanjiModel
    let type: Property
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: Settings.dinamicResaiseblePartsCornerRadius)
                .stroke(lineWidth: 2)
            
            if type == .on || type == .kun {
                VStack(spacing: Settings.paddingBetweenText) {
                    
                    HStack {
                        Text(title)
                            .bold()
                        Spacer()
                    }
                    
                    
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            ForEach(readingArray(), id: \.self) { row in
                                Text(row)
                            }
                        }
                        
                        Spacer()
                    }
                    
                }
                .padding(10)
            } else {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Text(readingArray()[0])
                            .padding(Settings.paddingBetweenElements)
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }
    
    func readingArray() -> [String] {
        switch type {
        case .kun:
            return kanji.kun.components(separatedBy: "・")
        case .on:
            return kanji.on.components(separatedBy: "・")
        case .translate:
            return [kanji.translate]
        case _:
            return [""]
        }
    }
    
}

struct LearningCell_Previews: PreviewProvider {
    static var previews: some View {
        LearningCell(title: "訓読み:", kanji: .MOCK_KANJI, type: .kun)
            .frame(maxWidth: .infinity, maxHeight: 100)
            .padding(Settings.padding)
        
        LearningCell(title: "例:", kanji: .MOCK_KANJI, type: .examples)
            .frame(maxWidth: .infinity, maxHeight: 100)
            .padding(Settings.padding)
    }
}
