//
//  KanaModel.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/24.
//

import Foundation

struct KanaModel: Codable {
    
    let hiragana: String
    let katakana: String
    let yaCombination: String
    let yuCombination: String
    let yoCombination: String
    let reading: String
}
