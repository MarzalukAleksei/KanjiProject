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
            
            result.append(.init(body: "body", number: "", reading: "", translate: [], examples: [], references: [], mainData: row))
        }
        return result
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

