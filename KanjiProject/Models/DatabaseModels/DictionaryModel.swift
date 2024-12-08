//
//  DictionaryModel.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/06/22.
//

import SwiftUI

struct DictionaryModel: Codable, Hashable {
    
    var body: String
    var number: String
    var reading: String
    var translate: [String]
    var examples: [String] = []
    var mainData: String = ""
}

extension DictionaryModel {
    
//    static var dictionary: [DictionaryModel] = [.MOCK_DICTIONARY, .MOCK_DICTIONARY, .MOCK_DICTIONARY,
//                                                .MOCK_DICTIONARY, .MOCK_DICTIONARY, .MOCK_DICTIONARY]
    
    static let MOCK_DICTIONARY: DictionaryModel = .init(body: "相生",
                                                        number: "007-06-37",
                                                        reading: "あいおい",
                                                        translate: ["совместное произрастание", "близнецы"],
                                                        examples: ["～する вместе расти;", "相生の松 двуствольная сосна;"],
                                                        mainData:
                                                                """
                                                                あいおい【相生】(аиои)〔007-06-37〕
                                                                1) совместное произрастание;
                                                                ～する а) вместе расти; б) <i>см.</i> <a href="#003-24-00">あいおい【相老】(～する)</a>;
                                                                相生の松 двуствольная сосна;
                                                                2) близнецы.
                                                                """)
}

extension DictionaryModel {
    
    // MARK: Метод рекурсии, дающий в результат только в том случае если строка не пуста
    static func getFirstExample(word: DictionaryModel) -> String {
        var result = ""
        var word = word
        for example in word.examples where !word.examples.isEmpty {
            let example = example
            if example.count <= 3 {
                continue
            } else {
                result = example
                break
            }
        }
        result = result.removeNumberExampleRow()
        if result.count < 3, word.examples.count > 1 {
            word.examples.removeFirst()
            result = getFirstExample(word: word)
        }
        
        return result
    }
}
