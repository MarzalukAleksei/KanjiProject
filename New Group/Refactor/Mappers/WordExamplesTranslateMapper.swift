//
//  WordExamplesTranslateMapper.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/06/08.
//

import Foundation

class WordExamplesTranslateMapper: IDataMapper {
    typealias Result = [WordModel]
    typealias Entity = [String]
    
    func gettingData(entity: [String]) -> [WordModel] {
        var result: [WordModel] = []
        
        for row in entity {
            var row = row
            row = row.replacingOccurrences(of: "–", with: "-")
            if !row.contains("-") {
                continue
            }
            if row.first == "\"" {
                row.removeFirst()
                guard let quatationMarkIndex = row.firstIndex(of: "\"") else { continue }
                row.remove(at: quatationMarkIndex)
            }
            let divideRow = row.components(separatedBy: "***")
            row = divideRow[0]
            guard let dashAfterIndex = row.firstIndex(of: "-"),
                  var firstSpaceIndex = row.firstIndex(of: " ") else { continue }
            if let closeJapBracketIndex = row.firstIndex(of: "）") {
                firstSpaceIndex = row.index(closeJapBracketIndex, offsetBy: 1)
            }
            let body = String(row[row.startIndex..<firstSpaceIndex])
            let meaningInRussion = String(row[row.index(dashAfterIndex, offsetBy: 2)..<row.endIndex])
            result.append(WordModel(body: body,
                                    meaningInEnglish: "",
                                    meaningInRussian: meaningInRussion,
                                    reading: "",
                                    type: "",
                                    levels: [],
                                    levelInTag: []))
        }
        
        return result
    }
    
    
    func getData() -> [WordModel] {
        do {
            return gettingData(entity: FileMapper().transform(data: try FileManage().loadFile(fileName: "KanjiKankenExamplesTranslation", fileType: .txt)))
        } catch {
            return []
        }
    }
    
}
