//
//  UserWordList.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/09/14.
//

import Foundation

struct UserWordList: Codable {
    var kanji: [KanjiModel]
    var dictionary: [DictionaryModel]
}
