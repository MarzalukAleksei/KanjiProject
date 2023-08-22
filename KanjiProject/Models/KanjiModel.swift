//
//  KanjiModel.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/02.
//

import SwiftUI

struct KanjiModel: Hashable {
    let body: String
    let kun: String
    let on: String
    let translate: String
    let number: Int
    let level: Int
    var examples: [String] = []
    var rightAnwers = 0
    var wrongAnswers = 0
    var lastAnswerRight: Bool? = nil
}

extension KanjiModel: Codable {
    static let MOCK_KANJI: KanjiModel = KanjiModel(body: "使",
                                                   kun: "つか-える",
                                                   on: "シ",
                                                   translate: "Использовать",
                                                   number: 0,
                                                   level: 4)
    
    static func findExamples(_ dicdionary: FetchedResults<DictionaryCoreData>) -> [String] {
        var result: [String] = []
        
        return result
    }
}
