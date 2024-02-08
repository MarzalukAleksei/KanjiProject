//
//  KanjiModel.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/02.
//

import SwiftUI

struct KanjiModel: Hashable, Identifiable, IAnswers {
    var id = UUID()
    let body: String
    let kun: String
    let on: String
    let translate: String
    let number: Int
    let level: NouryokuLevel
    var examples: [String]
    var rightAnwers = 0
    var wrongAnswers = 0
    private var lastAnswerRight: Bool?
    
    init(id: UUID = UUID(), body: String, kun: String, on: String, translate: String, number: Int, level: NouryokuLevel, examples: [String] = [], rightAnwers: Int = 0, wrongAnswers: Int = 0, lastAnswerRight: Bool? = nil) {
        self.id = id
        self.body = body
        self.kun = kun
        self.on = on
        self.translate = translate
        self.number = number
        self.level = level
        self.examples = examples
        self.rightAnwers = rightAnwers
        self.wrongAnswers = wrongAnswers
        self.lastAnswerRight = lastAnswerRight
    }
    
    func lastAnswer() -> Bool? {
        lastAnswerRight
    }
    
    mutating func answer(set answer: Bool?) {
        self.lastAnswerRight = answer
    }
}

extension KanjiModel: Codable {
    static let MOCK_KANJI: KanjiModel = KanjiModel(body: "使",
                                                   kun: "つか-える",
                                                   on: "シ",
                                                   translate: "Использовать",
                                                   number: 0,
                                                   level: .N4,
                                                   lastAnswerRight: true)
    
}
