//
//  BushuModel.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/05/27.
//

import Foundation

struct BushuModel: Codable, Identifiable {
    let id: Int
    let body: String
    let meaning: String
    let name: String
    let variant: String
    let explanation: String
    let oftenUsed: Bool
    var lastAnswerRight: Bool?
}

extension BushuModel: IAnswers {
    func showlastAnswer() -> Bool? {
        lastAnswerRight
    }
    
    mutating func setAnswer(with answer: Bool?) {
        lastAnswerRight = answer
    }
    
    
}
