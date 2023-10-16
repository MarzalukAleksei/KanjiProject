//
//  KanjiKenteiModel.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/10/16.
//

import Foundation

enum ExampleType: String, Codable, CaseIterable {
    case easy = "［小］"
    case middle = "［中］"
    case hight = "［高］"
    case exception = "［外］"
}

struct KanjiKenteiModel: Codable {
    let body: String
    let reading: String
    let examples: [ExampleType: String]
    let examplesWithReading: [ExampleType: String]
    let meaning: String
    let keys: String
    let kenteiLevel: Int
    let stroke: Int
    var oldKanji = ""
}
