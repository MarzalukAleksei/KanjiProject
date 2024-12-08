//
//  KanjiFlow.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/10.
//

import SwiftUI

struct KanjiFlow: Hashable {
    let index: Int
    let kanji: [KanjiModel]
    let type: String
    
    init(index: Int, kanji: [KanjiModel], type: String) {
        self.index = index
        self.kanji = kanji
        self.type = type
    }
    
//    static func == (lhs: KanjiFlow, rhs: KanjiFlow) -> Bool {
//        if lhs.index == rhs.index {
//            return true
//        }
//        return false
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(index)
//    }
}

extension KanjiFlow {
    static let MOCK_KANJIFLOW = KanjiFlow(index: 0,
                                          kanji: [.MOCK_KANJI,
                                                  .MOCK_KANJI,
                                                  .MOCK_KANJI,
                                                  .MOCK_KANJI,
                                                  .MOCK_KANJI],
                                          type: "問")
}
