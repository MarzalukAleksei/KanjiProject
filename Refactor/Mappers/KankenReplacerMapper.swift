//
//  KanjiKenteiMapper.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/10/16.
//

import Foundation

class KankenReplacerMapper: IDataMapper {
    typealias Result = [KankenReplacer]
    
    typealias Entity = [String]
    
    func gettingData(entity: [String]) -> [KankenReplacer] {
        var result: [KankenReplacer] = []
        var entity = entity[0].components(separatedBy: "\n")
// убираем пробелы
        entity = entity.map { element in
            var element = element.replacingOccurrences(of: "                                                      ", with: "                  ")
            element = element.replacingOccurrences(of: "                  ", with: "+++")
            element = element.replacingOccurrences(of: "               ", with: "---")
            element = element.replacingOccurrences(of: "        ", with: "###")
            element = element.replacingOccurrences(of: "###     ", with: "+++")
//            element = element.replacingOccurrences(of: "###     ", with: "+++")
            element = element.replacingOccurrences(of: "+++###", with: "+++")
            element = element.replacingOccurrences(of: "+++---", with: "+++")
            element = element.replacingOccurrences(of: "---", with: "+++")
            element = element.replacingOccurrences(of: "     部首 ", with: "")
            element = element.replacingOccurrences(of: "###  ", with: "      ")
            element = element.replacingOccurrences(of: "読み方      ", with: "")
            element = element.replacingOccurrences(of: " 意味      ", with: "")
            element = element.replacingOccurrences(of: "+++", with: "\n")
            return element
        }
        let array = entity.map { $0.components(separatedBy: "\n") }
        for elementt in array.enumerated() where elementt.element.count > 2 {
            let element = elementt.element
            
//            if element.first == "仞" {
//                print(element)
//            }
            
            var body = ""
            var defaultReading = ""
//            var kunReading: [ExampleType: String] = [:]
//            var onReading: [ExampleType: String] = [:]
            var example: [SchoolLevel : String] = [:]
            var exampleWithReading: [SchoolLevel : String] = [:]
            var meaning = ""
            var keys = ""
            var kenteiLevel: KankenLevel = .級10
            var stroke = 0
            var oldKanji = ""
            
            if element.count == 7 {
                body = element[0]
                defaultReading = element[1]
//                kunReading = getTypeValue(element[1].components(separatedBy: "    ")[1])
//                onReading = getTypeValue(element[1].components(separatedBy: "    ")[0])
                meaning = element[2]
                keys = element[4]
                kenteiLevel = getKankeiLevel(element[5])
                stroke = getNumber(element[6])
            } else if element.count == 9 {
                body = element[0]
                example = getTypeValue(element[1])
                exampleWithReading = getTypeValue(element[2])
                defaultReading = element[3]
//                kunReading = getTypeValue(element[3].components(separatedBy: "    ")[1])
//                onReading = getTypeValue(element[3].components(separatedBy: "    ")[0])
                meaning = element[4]
                keys = element[6]
                kenteiLevel = getKankeiLevel(element[7])
                stroke = getNumber(element[8])
            } else if element.count == 11 {
                body = element[0]
                example = getTypeValue(element[1])
                oldKanji = element[3]
                exampleWithReading = getTypeValue(element[4])
                defaultReading = element[5]
//                kunReading = getTypeValue(element[5].components(separatedBy: "    ")[1])
//                onReading = getTypeValue(element[5].components(separatedBy: "    ")[0])
                meaning = element[6]
                keys = element[8]
                kenteiLevel = getKankeiLevel(element[9])
                stroke = getNumber(element[10])
            } else {
//                body = element[0]
            }
            
            result.append(KankenReplacer(body: body,
                                           defaultReading: defaultReading,
                                           kunReading: [:],
                                           onReading: [:],
                                           examples: example,
                                           examplesWithReading: exampleWithReading,
                                           meaning: meaning,
                                           keys: keys,
                                           kankenLevel: kenteiLevel,
                                           stroke: stroke,
                                           oldKanji: oldKanji))
        }
        return result
    }
    
    func getTypeValue(_ string: String) -> [SchoolLevel: String] {
        var result: [SchoolLevel: String] = [:]
        var string = string.replacingOccurrences(of: " ", with: "")
        for type in SchoolLevel.allCases.reversed() {
            if string.contains("\t") {
                let startIndex = string.index(string.endIndex, offsetBy: -2)
                string.removeSubrange(startIndex..<string.endIndex)
            }
            let array = string.components(separatedBy: type.rawValue)
            if array.count > 1 {
                result[type] = array[1]
                string = array[0]
            }
        }
        return result
    }
    
    private func getNumber(_ string: String) -> Int {
        var result: Int = 0
        for character in string where character.isNumber {
            result = result * 10 + (Int("\(character)") ?? 0)
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
