//
//  KanjiKenteiMapper.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/10/16.
//

import Foundation

class KankenMapper: IDataMapper {
    typealias Result = [KanjiKankenModel]
    
    typealias Entity = [String]
    
    func gettingData(entity: [String]) -> [KanjiKankenModel] {
        var result: [KanjiKankenModel] = []
        var entity = entity[0].components(separatedBy: "\n")
        
        for row in entity {
            let components = row.components(separatedBy: "\t")
            result.append(KanjiKankenModel(id: Int(components[0]) ?? 0,
                                           body: components[1],
                                           defaultReading: components[9],
                                           kunReading: getLevelMarked(components[4]),
                                           onReading: getLevelMarked(components[3]),
                                           examples: getLevelMarked(components[9]),
                                           examplesWithReading: getTextWithReadings(components[10]),
                                           translateExapmles: [:],
                                           meaning: components[7],
                                           keys: components[6],
                                           kankenLevel: getKankeiLevel(components[8]),
                                           stroke: Int(components[5]) ?? 0,
                                           oldKanji: components[2],
                                           link: components[11]))
        }
        return result
    }
    
    private func getTextWithReadings(_ component: String) -> [SchoolLevel: [[TextAndReading]]] {
        var result: [SchoolLevel: [[TextAndReading]]] = [:]
        let levelMarked = getLevelMarked(component)
        for row in levelMarked {
            var textReadings: [[TextAndReading]] = []
            let words = row.value.components(separatedBy: "・")
            for word in words {
                let indexes = indexes(word)
                var kanjiAndReading: [TextAndReading] = []
                var row = word
                for index in indexes.reversed() {
                    let reading = row[row.index(word.startIndex, offsetBy: index.op + 1)..<row.index(row.startIndex, offsetBy: index.close)]
                    let text = String(row[row.index(word.startIndex, offsetBy: index.op - 1)]) + String(row[row.index(word.startIndex, offsetBy: index.close + 1)..<row.endIndex])
                    row = String(row[row.startIndex..<row.index(row.startIndex, offsetBy: index.op - 1)])
                    kanjiAndReading.append(TextAndReading(text: text,
                                                          reading: String(reading)))
                }
                textReadings.append(kanjiAndReading.reversed())
            }
            
            result[row.key] = textReadings
        }
        return result
    }
    
    private func indexes(_ word: String) -> [(op: Int, close: Int)] {
        var result: [(op: Int, close: Int)] = []
        var openBraket = 0
        
        for (index, char) in word.enumerated() {
            if char == "[" {
                openBraket = index
            } else if char == "]" {
                result.append((op: openBraket, close: index))
//            } else if char == "、" {
//                result.append((index, index))
            }
        }
        return result
    }
    
    private func getLevelMarked(_ component: String) -> [SchoolLevel: String] {
        var result: [SchoolLevel: String] = [:]
        var row = component.replacingOccurrences(of: " ", with: "")
        for level in SchoolLevel.allCases.reversed() where row.contains(level.rawValue) {
            let array = row.components(separatedBy: level.rawValue)
            if array.count > 1 {
                result[level] = array[1]
                row = array[0]
            } else {
                result[level] = array[0]
            }
        }
        return result
    }
    
    private func getKankeiLevel(_ string: String) -> KankenLevel {
        var result: String = ""
        for character in string where character.isNumber {
            result += String(character)
        }
        if string.contains("準") {
            result += "準"
        } else {
            result += "級"
        }
        for level in KankenLevel.allCases where result.count < 3 {
            let result = "0" + result
            if level.rawValue == result {
                return level
            }
        }
        return KankenLevel.級10
    }
}
