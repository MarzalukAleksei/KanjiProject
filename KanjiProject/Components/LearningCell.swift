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
    
    var kanji: KanjiModel = .MOCK_KANJI
    let type: Property
    var dictionary: DictionaryModel = .MOCK_DICTIONARY
    var chevronForwardIsHidden = true
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: Settings.dinamicResaiseblePartsCornerRadius)
                .stroke(lineWidth: 2)
            
            if type == .on || type == .kun {
                VStack(spacing: Settings.paddingBetweenText) {
                    
                    HStack {
                        Text(title())
                            .bold()
                        Spacer()
                    }
                    
                    
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            ForEach(separate(), id: \.self) { row in
                                Text(row)
                            }
                        }
                        
                        Spacer()
                    }
                    
                }
                .padding(Settings.paddingBetweenElements)
            } else if type == .translate {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Text(separate()[0])
                            .padding(Settings.paddingBetweenElements)
                        Spacer()
                    }
                    Spacer()
                }
            } else if type == .examples {
                HStack {
                    VStack(alignment: .leading) {
                        Text(dictionary.reading)
                            .font(.system(size: 12))
                            .opacity(Settings.opacity)
                        ForEach(separate(), id: \.self) { item in
                            VStack {
                                Text(item)
                                    .bold()
                            }
                        }
                        Spacer()
                    }
                    .padding(Settings.paddingBetweenElements)
                    
                    if !dictionary.translate.isEmpty {
                        let translate = DictionaryModel.getFirstExample(word: dictionary)
                        
                        JoinedTextView(text: translate)
                    }
                    
                    Spacer()
                    
                    if !chevronForwardIsHidden {
                        Image(systemName: "chevron.forward")
                            .padding(Settings.paddingBetweenElements)
                            .opacity(Settings.opacity)
                    }
                }
            }
        }
    }
    
    func title() -> String {
        if type == .on {
            return "音読み"
        } else if type == .kun {
            return "訓読み"
        }
        return ""
    }
    
    func separate() -> [String] {
        switch type {
        case .kun:
            return kanji.kun.components(separatedBy: "・")
        case .on:
            return kanji.on.components(separatedBy: "・")
        case .translate:
            return [kanji.translate]
        case .examples:
            return dictionary.body.components(separatedBy: "･")
        }
    }
    
}

struct LearningCell_Previews: PreviewProvider {
    static var previews: some View {
        LearningCell(kanji: .MOCK_KANJI, type: .kun)
            .frame(maxWidth: .infinity, maxHeight: 100)
            .padding(Settings.padding)
        
        LearningCell(kanji: .MOCK_KANJI, type: .examples)
            .frame(maxWidth: .infinity, maxHeight: 100)
            .padding(Settings.padding)
        
        LearningCell(kanji: .MOCK_KANJI, type: .examples, chevronForwardIsHidden: false)
            .frame(maxWidth: .infinity, maxHeight: 100)
            .padding(Settings.padding)
    }
}
