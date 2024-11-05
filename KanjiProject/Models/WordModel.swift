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
    func showlastAnswer() -> Bool? {
        return lastAnswerRight
    }
    
    mutating func setAnswer(with answer: Bool?) {
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
    static var MOCK = WordModel(body: "生長", meaningInEnglish: "growth (of a plant)", meaningInRussian: "", reading: "生[せい]長[ちょう]", type: "Noun, Suru verb, Intransitive verb", levels: ["jlpt-n2"], levelInTag: [KanjiProject.NouryokuLevel.N5], lastAnswerRight: nil)
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
    
    func getTextAndReading() -> [TextAndReading] {
        var word = self
        word.reading = word.reading.replacingOccurrences(of: "[", with: "(")
        word.reading = word.reading.replacingOccurrences(of: "]", with: ")")
        var result: [TextAndReading] = []
        let array = word.reading.components(separatedBy: ")")
        for element in array where element != "" {
            let parts = element.components(separatedBy: "(")
            if parts.count > 1 {
                result.append(.init(text: parts[0], reading: parts[1]))
            } else {
                result.append(.init(text: parts[0], reading: ""))
            }
        }
        return result
//        var result: [TextAndReading] = []
//        let components = self.reading.components(separatedBy: " ")
//        for part in components {
//            if part.contains("[") {
//                guard let startIndex = part.firstIndex(of: "["),
//                      let endIndex = part.firstIndex(of: "]") else { return [] }
//                
//                let text = String(part[part.startIndex..<startIndex] + part[part.index(after: endIndex)..<part.endIndex])
//                let reading = String(part[part.index(after: startIndex)..<endIndex])
//                
//                result.append(TextAndReading(text: text, reading: reading))
//            } else if components.count < 2 {
//                result.append(TextAndReading(text: self.body, reading: self.reading))
//            } else {
//                result.append(TextAndReading(text: part, reading: ""))
//            }
//        }
//        return result
    }
}
