//
//  UsersWordsMapper.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2025/05/13.
//

import Foundation

class UsersWordsMapper: IDataMapper {
    typealias Result = [WordModel]
    typealias Entity = [String]
    
    func gettingData(entity: [String]) -> [WordModel] {
        var result: [WordModel] = []
        for row in entity {
            var row = row.replacingOccurrences(of: "-", with: "—")
            let meaning = meaning(&row)
            let reading = reading(&row)
            let ar = meaning.components(separatedBy: "***")
            row = row.replacingOccurrences(of: " ", with: "")
            result.append(.init(body: row,
                                meaningInEnglish: "",
                                meaningInRussian: ar[0],
                                meaningInJapanese: ar.count > 1 ? ar[1] : nil,
                                reading: row + "[" + reading + "]",
                                type: "", levels: [], levelInTag: []))
        }
        return result
    }
    
    private func reading(_ row: inout String) -> String {
        row = row.replacingOccurrences(of: "（", with: "(")
        row = row.replacingOccurrences(of: "）", with: ")")
        guard let openBracketIndex = row.firstIndex(of: "("),
              let closeBracketIndex = row.firstIndex(of: ")") else { return "" }
        let result = String(row[row.index(after: openBracketIndex)..<closeBracketIndex])
        row = String(row[row.startIndex..<row.index(openBracketIndex, offsetBy: -1)])
        return result
    }
    
    private func meaning(_ row: inout String) -> String {
        guard let dashIndex = row.firstIndex(of: "—") else { return "" }
        guard let meaningStartIndex = row.index(dashIndex, offsetBy: 2, limitedBy: row.endIndex) else {
            row = String(row[row.startIndex..<dashIndex])
            return ""
        }
        let result = String(row[meaningStartIndex..<row.endIndex])
        row = String(row[row.startIndex..<dashIndex])
        return result
    }
}
