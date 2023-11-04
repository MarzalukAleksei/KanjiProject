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

struct KanjiKankenModel: Codable, Hashable {
    let body: String
    let defaultReading: String
    var kunReading: [ExampleType: String]
    var onReading: [ExampleType: String]
    let examples: [ExampleType: String]
    let examplesWithReading: [ExampleType: String]
    let meaning: String
    let keys: String
    let kankenLevel: KankenLevel
    let stroke: Int
    var oldKanji = ""
    var lastAnswer: Bool? = nil
}

extension KanjiKankenModel {
    static let MOCK_KANJIKENTEI = KanjiKankenModel(body: "舞",
                                            defaultReading: "［中］ブ ［外］ム    ［中］まい、ま（う） ［外］もてあそ（ぶ）",
                                            kunReading: [.exception: "もてあそ（ぶ）"],
                                            onReading: [.middle: "ブ"],
                                            examples: [.middle: "舞う・舞・舞姫・舞台・舞踏・見舞う・歌舞伎・見舞い"],
                                            examplesWithReading: [.middle: "舞まう・舞まい・舞まい姫ひめ・舞ぶ台たい・舞ぶ踏とう・見み舞まう・歌か舞ぶ伎き・見み舞まい"],
                                            meaning: "① まう。踊る。 ② まわす。はげます。奮い立たせる。 ③ もてあそぶ。思いのままにあつかう。",
                                            keys: "舛",
                                            kankenLevel: .級04,
                                            stroke: 15)
}
