//
//  KanjiFileMapper.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2025/06/01.
//

import Foundation

class KanjiFileMapper: IDataMapper {
    
    typealias Result = [(String, String)]
    
    typealias Entity = [String]
    
    func gettingData(entity: [String]) -> [(String, String)] {
        var result: [(String, String)] = []
        
        for row in entity {
            let dashIndex = row.index(row.startIndex, offsetBy: 2)
            let body = String(row[row.startIndex..<row.index(before: dashIndex)])
            let meaning = String(row[row.index(dashIndex, offsetBy: 2)..<row.endIndex])
            result.append((body, meaning))
        }
        
        return result
    }
    
}
