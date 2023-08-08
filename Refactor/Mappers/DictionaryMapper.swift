//
//  DictionaryMapper.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/06/22.
//

import Foundation

class DictionaryMapper: IDictionaryMapper {
    
    enum DisplayMode {
        case colored
    }
    
    var dictionary: [DisplayMode: String] = [:]
    
    
    
    typealias Result = [DictionaryModel]
    typealias Entity = [String]
    
    func gettingData(entity: [String]) -> [DictionaryModel] {
        var result: [DictionaryModel] = []
        
        var entiry = entity
        entiry.removeFirst()
        
        for row in entiry {
            var innerRows = row.split(separator: "\n").map { String($0) }
            let firstRow = innerRows.removeFirst()
            let body = value(from: "【", to: "】", in: firstRow)
            let number = value(from: "〔", to: "〕", in: firstRow)
            let reading = getReading(string: firstRow)
            let translate: [String] = []
            let examples: [String] = removeTrash(array: innerRows)
            
            result.append(.init(body: body, number: number, reading: reading, translate: translate, examples: examples))
        }
        return result
    }
    
    private func replacingTwoMarks(first firstMark: String, second secondMark: String, array: [String]) -> [String] {
        
        return []
    }
    
    private func removeTrash(array: [String]) -> [String] {
        var result = array
        result = result.map { $0.replacingOccurrences(of: "<i>", with: "") }
        result = result.map { $0.replacingOccurrences(of: "</i>", with: "") }
        result = result.map { $0.replacingOccurrences(of: "<a href=\"", with: "") }
        result = result.map { $0.replacingOccurrences(of: "\">", with: "$#") }
        result = result.map { $0.replacingOccurrences(of: "</a>", with: "") }
        return result
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
