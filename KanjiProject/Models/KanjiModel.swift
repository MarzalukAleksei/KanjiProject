//
//  KanjiModel.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/02.
//

struct KanjiModel: Hashable {
    let body: String
    let kun: String
    let on: String
    let translate: String
    let number: Int
    let level: Int
    var examples: [String] = []
//    var madeMistake: Bool = false
    var rightAnwers = 0
    var wrongAnswers = 0
}

extension KanjiModel {
    static let MOCK_KANJI: KanjiModel = KanjiModel(body: "使",
                                                   kun: "つか-える",
                                                   on: "シ",
                                                   translate: "Использовать",
                                                   number: 0,
                                                   level: 4)
}
