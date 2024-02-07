//
//  WordModel.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/02/06.
//

import Foundation

struct WordModel: Codable, Hashable, IAnswers {
    var id: UUID?
    var body: String
    let meaningInEnglish: String
    var meaningInRussian: String
    let reading: String
    let type: String
    let levels: [String]
    let levelInTag: [NouryokuLevel]
    private var lastAnswerRight: Bool?
    
    init(body: String, meaningInEnglish: String, meaningInRussian: String, reading: String, type: String, levels: [String], levelInTag: [NouryokuLevel], lastAnswerRight: Bool? = nil) {
        self.body = body
        self.meaningInEnglish = meaningInEnglish
        self.meaningInRussian = meaningInRussian
        self.reading = reading
        self.type = type
        self.levels = levels
        self.levelInTag = levelInTag
        self.lastAnswerRight = lastAnswerRight
    }
    
    func lastAnswer() -> Bool? {
        return lastAnswerRight
    }
    
    mutating func answer(set answer: Bool?) {
        lastAnswerRight = answer
    }
}

extension WordModel {
    static var MOCK = WordModel(body: "生長", meaningInEnglish: "growth (of a plant)", meaningInRussian: "", reading: "生長[せいちょう]", type: "Noun, Suru verb, Intransitive verb", levels: ["jlpt-n2"], levelInTag: [KanjiProject.NouryokuLevel.N2], lastAnswerRight: nil)
}
