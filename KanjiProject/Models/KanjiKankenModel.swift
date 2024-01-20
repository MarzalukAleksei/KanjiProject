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
    private let examplesWithReading: [SchoolLevel: [[TextAndReading]]]
    var translateExapmles: [SchoolLevel: [String]]
    let meaning: String
    let keys: String
    let kankenLevel: KankenLevel
    let stroke: Int
    var oldKanji = ""
    var lastAnswer: Bool? = nil
    
    init(body: String, defaultReading: String, kunReading: [SchoolLevel : String], onReading: [SchoolLevel : String], examples: [SchoolLevel : String], examplesWithReading: [SchoolLevel : [[TextAndReading]]], translateExapmles: [SchoolLevel : [String]] = [:], meaning: String, keys: String, kankenLevel: KankenLevel, stroke: Int, oldKanji: String = "", lastAnswer: Bool? = nil) {
        self.body = body
        self.defaultReading = defaultReading
        self.kunReading = kunReading
        self.onReading = onReading
        self.examples = examples
        self.examplesWithReading = examplesWithReading
        self.translateExapmles = translateExapmles
        self.meaning = meaning
        self.keys = keys
        self.kankenLevel = kankenLevel
        self.stroke = stroke
        self.oldKanji = oldKanji
        self.lastAnswer = lastAnswer
    }
    
    func getExamplesWithReading() -> [SchoolLevel: [[TextAndReading]]] {
        return examplesWithReading
    }
    
    func getExamplesWithReading(_ level: SchoolLevel) -> [[TextAndReading]]? {
//        return examplesWithReading[level]
        return removeEmpty()[level]
    }
    
    private func removeEmpty(_ level: SchoolLevel? = nil) -> [SchoolLevel: [[TextAndReading]]] {
        var result = examplesWithReading
        for level in result {
            var newArray: [[TextAndReading]] = []
            for word in level.value {
                var currentWord: [TextAndReading] = []
                for part in word {
                    if part.reading != "" {
                        currentWord.append(part)
                    }
                }
                newArray.append(currentWord)
            }
            result[level.key] = newArray
        }
        return result
    }
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

extension KanjiKankenModel {
    static let ANOTHER_MOCK_KANKENKANJI = KanjiKankenModel(body: "亢",
                                                           defaultReading: "［外］コウ    ［外］あ（がる）、あ（たる）、きわ（める）、たか（い）、たかぶ（る）、のど",
                                                           kunReading: [KanjiProject.SchoolLevel.exception: "あ（がる）、あ（たる）、きわ（める）、たか（い）、たかぶ（る）、のど"],
                                                           onReading: [KanjiProject.SchoolLevel.exception: "コウ"],
                                                           examples: [KanjiProject.SchoolLevel.exception: "亢い・亢る・亢たる・亢がる・亢める・亢（１）・亢（２）・亢進・亢竜・心悸亢進・亢竜有悔・亢竜、悔いあり"],
                                                           examplesWithReading: [KanjiProject.SchoolLevel.exception: [[KanjiProject.TextAndReading(text: "亢い", reading: "たか")], [KanjiProject.TextAndReading(text: "亢る", reading: "たかぶ")], [KanjiProject.TextAndReading(text: "亢たる", reading: "あ")], [KanjiProject.TextAndReading(text: "亢がる", reading: "あ")], [KanjiProject.TextAndReading(text: "亢める", reading: "きわ")], [KanjiProject.TextAndReading(text: "亢（１）", reading: "こう")], [KanjiProject.TextAndReading(text: "亢（２）", reading: "のど")], [KanjiProject.TextAndReading(text: "亢", reading: "こう"), KanjiProject.TextAndReading(text: "進", reading: "しん")], [KanjiProject.TextAndReading(text: "亢", reading: "こう"), KanjiProject.TextAndReading(text: "竜", reading: "りょう")], [KanjiProject.TextAndReading(text: "心", reading: "しん"), KanjiProject.TextAndReading(text: "悸", reading: "き"), KanjiProject.TextAndReading(text: "亢", reading: "こう"), KanjiProject.TextAndReading(text: "進", reading: "しん")], [KanjiProject.TextAndReading(text: "亢", reading: "こう"), KanjiProject.TextAndReading(text: "竜", reading: "りょう"), KanjiProject.TextAndReading(text: "有", reading: "ゆう"), KanjiProject.TextAndReading(text: "悔", reading: ""), KanjiProject.TextAndReading(text: "悔", reading: "かい")], [KanjiProject.TextAndReading(text: "亢", reading: "こう"), KanjiProject.TextAndReading(text: "竜、", reading: "りょう"), KanjiProject.TextAndReading(text: "悔", reading: ""), KanjiProject.TextAndReading(text: "悔いあり", reading: "く")]]],
                                                           translateExapmles: [:], meaning: "【A】コウ のど。くび。くびすじ。 【B】コウ ① あがる。あげる。高く上がる。 ② あたる。匹敵する。対等である。 ③ きわめる。きわまる。 ④ たかい。たかぶる。 ⑤ 二十八宿の一つ。あみぼし。",
                                                           keys: "亠",
                                                           kankenLevel: KanjiProject.KankenLevel.級01,
                                                           stroke: 4,
                                                           oldKanji: "",
                                                           lastAnswer: nil)
}
