//
//  KankenReplacer.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/11/04.
//

import Foundation

struct KankenReplacer: Codable, Hashable {
    let body: String
    let defaultReading: String
    var kunReading: [SchoolLevel: String]
    var onReading: [SchoolLevel: String]
    let examples: [SchoolLevel: String]
    let examplesWithReading: [SchoolLevel: String]
    let meaning: String
    let keys: String
    let kankenLevel: KankenLevel
    let stroke: Int
    var oldKanji = ""
    var lastAnswer: Bool? = nil
}
