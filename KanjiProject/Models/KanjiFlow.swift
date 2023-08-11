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
    
    init(index: Int, kanji: [KanjiModel]) {
        self.index = index
        self.kanji = kanji
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
                                                  .MOCK_KANJI])
}
