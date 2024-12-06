//
//  NouryokuWord.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/10/31.
//

import Foundation

struct NouryokuWord: Identifiable {
    let id = UUID()
    var body: String
    var reading: String
    let oldLevel: Int
    let origin: String
    var transtale: String?
    var inEnglish: String?
}
