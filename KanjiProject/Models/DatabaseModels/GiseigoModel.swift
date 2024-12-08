//
//  GiseigoModel.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/09/13.
//

import Foundation

struct GiseigoModel: Codable {
    let word: String
    let examples: [String]
    let role: [String]
    let wordTranslate: [String]
    let examplesTranslate: [String]
    let sameWords: [String]
    let root: [String]
    let difficulty: Int
    var learned: Bool
}
