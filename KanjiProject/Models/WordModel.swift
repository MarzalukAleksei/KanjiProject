//
//  WordModel.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/02/06.
//

import SwiftUI

struct WordModel: Codable, Hashable, Identifiable {
    var id: UUID?
    var body: String
    let meaningInEnglish: String
    var meaningInRussian: String
    var reading: String
    let type: String
    let levels: [String]
    let levelInTag: [NouryokuLevel]
    private var lastAnswerRight: Bool?
    private var _rightAnswersInRow: Int?
    
    init(body: String, meaningInEnglish: String, meaningInRussian: String, reading: String, type: String, levels: [String], levelInTag: [NouryokuLevel], lastAnswerRight: Bool? = nil, rightAnswersInRow: Int? = nil) {
        self.id = UUID()
        self.body = body
        self.meaningInEnglish = meaningInEnglish
        self.meaningInRussian = meaningInRussian
        self.reading = reading
        self.type = type
        self.levels = levels
        self.levelInTag = levelInTag
        self.lastAnswerRight = lastAnswerRight
        self._rightAnswersInRow = rightAnswersInRow
    }
    
    init(body: String, meaningInEnglish: String, level: NouryokuLevel) {
        self.id = UUID()
        self.body = body
        self.meaningInEnglish = meaningInEnglish
        self.levelInTag = [level]
        self.meaningInRussian = ""
        self.reading = ""
        self.type = ""
        self.lastAnswerRight = nil
        self.levels = []
    }
}

extension WordModel: IAnswers {
    func lastAnswer() -> Bool? {
        return lastAnswerRight
    }
    
    mutating func answer(set answer: Bool?) {
        lastAnswerRight = answer
        setRightAnswer(answer)
    }
}

extension WordModel {
    func rightAnswersInRow() -> Int {
        guard let rightAnswersInRow = _rightAnswersInRow else { return 0 }
        return rightAnswersInRow
    }
    
    private mutating func setRightAnswer(_ answer: Bool?) {
        if answer == true {
            if var rightAnswersInRow = _rightAnswersInRow { // if non Optional
                rightAnswersInRow += 1
                self._rightAnswersInRow = rightAnswersInRow
            } else { // if Optional
                _rightAnswersInRow = 1
            }
        } else {
            _rightAnswersInRow = 0
        }
    }
}

extension WordModel {
    static var MOCK = WordModel(body: "生長", meaningInEnglish: "growth (of a plant)", meaningInRussian: "", reading: "生長[せいちょう]", type: "Noun, Suru verb, Intransitive verb", levels: ["jlpt-n2"], levelInTag: [KanjiProject.NouryokuLevel.N2], lastAnswerRight: nil)
}

extension WordModel {
    static var empty = WordModel(body: "",
                                 meaningInEnglish: "",
                                 meaningInRussian: "",
                                 reading: "",
                                 type: "",
                                 levels: [],
                                 levelInTag: [])
}

extension WordModel {
    init(components: [TextAndReading]) {
        self.body = ""
        self.meaningInEnglish = ""
        self.meaningInRussian = ""
        self.reading = ""
        self.type = ""
        self.levels = []
        self.levelInTag = []
        
        let transformed = transformToWord(with: components)
        self.body = transformed.body
        self.reading = transformed.reading
    }
    
    private func transformToWord(with components: [TextAndReading]) -> (body: String, reading: String) {
        var body = ""
        var reading = ""
        
        for component in components {
            body += component.text
            reading += "\(component.text)[\(component.reading)]"
        }
        return (body, reading)
    }
    
    func getSeparatedMeaning() -> [String] {
        let result = meaningInRussian.components(separatedBy: "・")
        return result
    }
}
