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
                        Text(title)
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
                    
                    
//                    if !dictionary.examples.isEmpty {
////                        let example = dictionary.examples[0].removeNumberExampleRow()
//                        let example = getExample(examples: dictionary.examples)
//
//                        if example.contains("<<<") {
//                            VStack(alignment: .leading) {
//                                JoinedTextView(textAndLinks: example.textAndLinks(), text: example)
//                            }
//                        } else {
//                            HStack {
//                                Text(example)
//                                Spacer()
//                            }
//                        }
//                    }
                    
                    if !dictionary.translate.isEmpty {
//                        let translate = getExample(examples: dictionary.translate)
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
    
//    func getExample(examples: [String]) -> String {
//        var result = ""
//        var examples = examples
//        for row in examples where !dictionary.examples.isEmpty {
//            let row = row
//            if row.count <= 3 {
//                continue
//            } else {
//                result = row
//                break
//            }
//        }
//        result = result.removeNumberExampleRow()
//        if result.count < 3, examples.count > 1 {
//            examples.removeFirst()
//            result = getExample(examples: examples)
//        }
//        
//        return result
//    }
    
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
        LearningCell(title: "訓読み:", kanji: .MOCK_KANJI, type: .kun)
            .frame(maxWidth: .infinity, maxHeight: 100)
            .padding(Settings.padding)
        
        LearningCell(title: "例:", kanji: .MOCK_KANJI, type: .examples)
            .frame(maxWidth: .infinity, maxHeight: 100)
            .padding(Settings.padding)
        
        LearningCell(title: "例:", kanji: .MOCK_KANJI, type: .examples, chevronForwardIsHidden: false)
            .frame(maxWidth: .infinity, maxHeight: 100)
            .padding(Settings.padding)
    }
}
