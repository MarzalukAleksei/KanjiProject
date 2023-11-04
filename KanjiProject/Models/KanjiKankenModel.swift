//
//  KanjiKenteiModel.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/10/16.
//

import Foundation

enum SchoolLevel: String, Codable, CaseIterable {
    case easy = "［小］"
    case middle = "［中］"
    case hight = "［高］"
    case exception = "［外］"
}

struct KanjiKankenModel: Codable, Hashable {
    let body: String
    let defaultReading: String
    var kunReading: [SchoolLevel: String]
    var onReading: [SchoolLevel: String]
    let examples: [SchoolLevel: String]
    let examplesWithReading: [SchoolLevel: [[TextAndReading]]]
    var translateExapmles: [SchoolLevel: [String]] = [:]
    let meaning: String
    let keys: String
    let kankenLevel: KankenLevel
    let stroke: Int
    var oldKanji = ""
    var lastAnswer: Bool? = nil
}

extension KanjiKankenModel {
    static let MOCK_KANJIKENTEI = KanjiKankenModel(body: "踞",
                                            defaultReading: "［外］キョ、コ    ［外］うずくま（る）、おご（る）",
                                            kunReading: [KanjiProject.SchoolLevel.exception: "うずくま（る）、おご（る）"],
                                            onReading: [KanjiProject.SchoolLevel.exception: "キョ、コ"],
                                            examples: [KanjiProject.SchoolLevel.exception: "踞る（１）・踞る（２）・箕踞・蹲踞・踞座・蟠踞・虎踞竜蟠・竜蟠虎踞"],
                                            examplesWithReading: [KanjiProject.SchoolLevel.exception: [[KanjiProject.TextAndReading(text: "踞る（１）", reading: "うずくま")], [KanjiProject.TextAndReading(text: "踞る（２）", reading: "おご")], [KanjiProject.TextAndReading(text: "箕", reading: "き"), KanjiProject.TextAndReading(text: "踞", reading: "きょ")], [KanjiProject.TextAndReading(text: "蹲", reading: "そん"), KanjiProject.TextAndReading(text: "踞", reading: "きょ")], [KanjiProject.TextAndReading(text: "踞", reading: "きょ"), KanjiProject.TextAndReading(text: "座", reading: "ざ")], [KanjiProject.TextAndReading(text: "蟠", reading: "ばん"), KanjiProject.TextAndReading(text: "踞", reading: "きょ")], [KanjiProject.TextAndReading(text: "虎", reading: "こ"), KanjiProject.TextAndReading(text: "踞", reading: "きょ"), KanjiProject.TextAndReading(text: "竜", reading: "りょう"), KanjiProject.TextAndReading(text: "蟠", reading: "ばん")], [KanjiProject.TextAndReading(text: "竜", reading: "りょう"), KanjiProject.TextAndReading(text: "蟠", reading: "ばん"), KanjiProject.TextAndReading(text: "虎", reading: "こ"), KanjiProject.TextAndReading(text: "踞", reading: "きょ")]]],
                                            meaning: "① しゃがむ。うずくまる。ひざを立てて座る。 ② 腰掛ける。よりかかる。 ③ おごる。おごりたかぶる。",
                                            keys: "足",
                                            kankenLevel: .級01,
                                            stroke: 15)
}

extension KanjiKankenModel {
    
    mutating func translateExamples() async {
        self.translateExapmles = [:]
    }
}
