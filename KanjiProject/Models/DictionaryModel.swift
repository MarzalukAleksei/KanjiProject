//
//  DictionaryModel.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/06/22.
//

import SwiftUI

struct DictionaryModel: Codable, Hashable {
    
    var body: String
    var number: String
    var reading: String
    var translate: [String]
    var examples: [String] = []
    var mainData: String = ""
}

extension DictionaryModel {
    
//    static var dictionary: [DictionaryModel] = [.MOCK_DICTIONARY, .MOCK_DICTIONARY, .MOCK_DICTIONARY,
//                                                .MOCK_DICTIONARY, .MOCK_DICTIONARY, .MOCK_DICTIONARY]
    
    static let MOCK_DICTIONARY: DictionaryModel = .init(body: "相生",
                                                        number: "007-06-37",
                                                        reading: "あいおい",
                                                        translate: ["совместное произрастание", "близнецы"],
                                                        examples: ["～する вместе расти;", "相生の松 двуствольная сосна;"],
                                                        mainData:
                                                                """
                                                                あいおい【相生】(аиои)〔007-06-37〕
                                                                1) совместное произрастание;
                                                                ～する а) вместе расти; б) <i>см.</i> <a href="#003-24-00">あいおい【相老】(～する)</a>;
                                                                相生の松 двуствольная сосна;
                                                                2) близнецы.
                                                                """)
}

extension DictionaryModel {
    
//    static func textAndLinks(text: String) -> [(isText: Bool, text: String)] {
//        var result: [(isText: Bool, text: String)] = []
//        let links = links(text: text)
//        var newText = text
//
//        for index in (0..<links.count).reversed() {
//            newText = newText.replacingCharacters(in: links[index].rightBracket.startIndex...links[index].rightBracket.lastIndex, with: "")
//            newText = newText.replacingCharacters(in: text.index(after: links[index].leftBracket.lastIndex)...text.index(before: links[index].rightBracket.startIndex), with: "###\(index)")
//            newText = newText.replacingCharacters(in: links[index].leftBracket.startIndex...links[index].leftBracket.lastIndex, with: "")
//        }
//        var array: [String] = []
//        for index in 0..<links.count {
//            array = newText.components(separatedBy: "###\(index)")
//
//            result.append((isText: true, text: array.removeFirst()))
//
//            let afterIndex = text.index(after: links[index].leftBracket.lastIndex)
//            let beforeIndex = text.index(before: links[index].rightBracket.startIndex)
//            let middleText = String(text[afterIndex...beforeIndex])
//            result.append((isText: false, text: middleText))
//
//            if index + 1 == links.count {
//                result.append((isText: true, text: array.removeFirst()))
//            }
//        }
//
//        return result
//    }
//
//    static private func links(text: String) -> [(leftBracket: (startIndex: String.Index,
//                                                       lastIndex: String.Index),
//                                         rightBracket: (startIndex: String.Index,
//                                                        lastIndex: String.Index))] {
//
//        var result: [(leftBracket: (startIndex: String.Index,
//                                    lastIndex: String.Index),
//                      rightBracket: (startIndex: String.Index,
//                                     lastIndex: String.Index))] = []
//
//        var leftBrackes: [(firstIndex: String.Index, lastIndex: String.Index)] = []
//        var rightBrackets: [(firstIndex: String.Index, lastIndex: String.Index)] = []
//
//        var offSet = 0
//        var startIndex: String.Index {
//            text.index(text.startIndex, offsetBy: offSet, limitedBy: text.endIndex) ?? text.startIndex
//        }
//        var lastIndex: String.Index {
//            text.index(text.startIndex, offsetBy: offSet + 2, limitedBy: text.endIndex) ?? text.startIndex
//        }
//
//        for index in 0..<text.count - 2 {
//            offSet = index
//
//            if text[startIndex...lastIndex] == "<<<" {
//                leftBrackes.append((startIndex, lastIndex))
//            }
//
//            if text[startIndex...lastIndex] == ">>>" {
//                rightBrackets.append((startIndex, lastIndex))
//            }
//        }
//
//        for index in 0..<leftBrackes.count {
//            result.append((leftBracket: (startIndex: leftBrackes[index].firstIndex,
//                                         lastIndex: leftBrackes[index].lastIndex),
//                           rightBracket: (startIndex: rightBrackets[index].firstIndex,
//                                          lastIndex: rightBrackets[index].lastIndex)))
//        }
//        print(result)
//        return result
//    }
}
