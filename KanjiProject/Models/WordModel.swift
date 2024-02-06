//
//  WordModel.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/02/06.
//

import Foundation

struct WordModel: Codable, Hashable {
    let body: String
    let meaningInEnglish: String
    var meaningInRussian: String
    let reading: String
    let type: String
    let levels: [String]
    let levelInTag: [NouryokuLevel]
}
