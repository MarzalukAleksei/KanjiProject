//
//  DictionaryModel.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/06/22.
//

import Foundation

struct DictionaryModel: Codable {
    var body: String
    var number: String
    var reading: String
    var translate: [String]
    var examples: [String]
    var references: [String]
    var mainData: String = ""
}

extension DictionaryModel {
    static let MOCK_DICTIONARY: DictionaryModel = .init(body: "相生",
                                                        number: "007-06-37",
                                                        reading: "あいおい",
                                                        translate: ["совместное произрастание", "близнецы"],
                                                        examples: ["～する вместе расти;", "相生の松 двуствольная сосна;"],
                                                        references: ["003-24-00"],
                                                        mainData:
                                                                """
                                                                あいおい【相生】(аиои)〔007-06-37〕
                                                                1) совместное произрастание;
                                                                ～する а) вместе расти; б) <i>см.</i> <a href="#003-24-00">あいおい【相老】(～する)</a>;
                                                                相生の松 двуствольная сосна;
                                                                2) близнецы.
                                                                """)
}
