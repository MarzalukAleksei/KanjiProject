//
//  DictionaryMapper.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/06/22.
//

import Foundation

class DictionaryMapper: IDictionaryMapper {
    
    typealias Result = [DictionaryModel]
    typealias Entity = [String]
    
    func gettingData(entity: [String]) -> [DictionaryModel] {
        var result: [DictionaryModel] = []
        
        var entiry = entity
        entiry.removeFirst()
        
        for row in entiry {
            let innerRows = row.split(separator: "\n").map { String($0) }
            let body = value(from: "【", to: "】", in: innerRows.first ?? "")
//            let body = ""
            let number = value(from: "〔", to: "〕", in: innerRows.first ?? "")
//            let number = ""
            let reading = getReading(string: innerRows.first ?? "")
//            let reading = ""
            let translate: [String] = []
            let examples: [String] = []
            let references: [String] = []
            
            result.append(.init(body: body, number: number, reading: reading, translate: translate, examples: examples, references: references))
        }
        return result
    }
    
    private func replacingTwoMarks(first firstMark: String, second secondMark: String) {
        
    }
    
    private func getReading(string: String) -> String {
        var devider: String {
            if string.contains("【") {
                return "【"
            } else {
                return "("
            }
        }
        let array = string.components(separatedBy: devider)
        
        return array[0]
    }
    
    private func value(from first: Character, to second: Character, in string: String) -> String {
        let firstIndex = string.firstIndex(of: first)
        let lastIndex = string.lastIndex(of: second)
        guard let firstIndex = firstIndex,
              let lastIndex = lastIndex else { return "" }
        let indexRange = string.index(after: firstIndex)..<lastIndex
        let result = String(string[indexRange])
        return result
    }
    
}

