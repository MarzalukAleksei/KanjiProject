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
//            var word = WordModel.empty
            var row = row.replacingOccurrences(of: "-", with: "—")
            var body = ""
            var reading = ""
            guard let dashIndex = row.firstIndex(of: "—") else {
                print("Check value of \(row)")
                continue
            }
            if let openBracketIndex = row.firstIndex(of: "("),
               let closeBracketIndex = row.firstIndex(of: ")"),
                closeBracketIndex < dashIndex {
                reading = String(row[row.index(after: openBracketIndex)..<closeBracketIndex])
                body = String(row[row.startIndex..<row.index(before: openBracketIndex)])
            } else {
                body = String(row[row.startIndex..<row.index(before: dashIndex)])
            }
            let meaning = String(row[row.index(after: dashIndex)..<row.endIndex])
            let ar = meaning.components(separatedBy: "***")
            result.append(.init(body: body,
                                meaningInEnglish: "",
                                meaningInRussian: ar[0],
                                meaningInJapanese: ar.count > 1 ? ar[1] : nil,
                                reading: body + "[" + reading + "]",
                                type: "", levels: [], levelInTag: []))
        }
        return result
    }
}
