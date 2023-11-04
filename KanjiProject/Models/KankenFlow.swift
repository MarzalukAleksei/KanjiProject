//
//  KakkenFlow.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/11/04.
//

import Foundation

class KankenFlow: Hashable {
    
    let index: Int
    let kanji: [KanjiKankenModel]
    
    init(index: Int, kanji: [KanjiKankenModel]) {
        self.index = index
        self.kanji = kanji
    }
    
    static func == (lhs: KankenFlow, rhs: KankenFlow) -> Bool {
        return lhs.kanji == rhs.kanji
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(kanji)
    }
}
extension KankenFlow {
    static let MOCK: KankenFlow = KankenFlow(index: 1, kanji: [.MOCK_KANJIKENTEI, .MOCK_KANJIKENTEI, .MOCK_KANJIKENTEI])
}
