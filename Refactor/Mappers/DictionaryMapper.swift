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
            let removedTrash = removeTrash(array: innerRows)
            let body = firstRow.removeBetween("【", and: "】")
            let number = firstRow.removeBetween("〔", and: "〕")
            let reading = getReading(string: firstRow)
            let translate: [String] = setTranslate(text: removedTrash)
            let examples: [String] = removedTrash
            
            result.append(.init(body: body, number: number, reading: reading, translate: translate, examples: examples))
            
        }
        return result
    }
    
    private func setTranslate(text: [String]) -> [String] {
        var result: [String] = []
        
        for row in text {
            let index = row.index(row.startIndex, offsetBy: 1)
            
            if row.count > 2, row[index] == ")" {
                result.append(row)
            }
        }
        if result.isEmpty, !text.isEmpty  {
            result.append(text[0])
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
        result = result.map { $0.replacingOccurrences(of: "<a href=\"#", with: "<<<") }
        result = result.map { $0.replacingOccurrences(of: "\">", with: ">>>") }
        result = result.map { $0.replacingOccurrences(of: "</a>", with: "") }
        return result
    }
    
//    private func getTranslate(_ string: [String]) -> [String] {
//        var result: [String] = []
//        let
//        for row in string {
//            
//        }
//        
//        return []
//    }
    
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
    
    
    
}

