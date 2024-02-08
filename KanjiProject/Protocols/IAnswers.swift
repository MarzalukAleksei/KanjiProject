//
//  IAnswers.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/02/06.
//

import Foundation

protocol IAnswers {
    func lastAnswer() -> Bool?
    
    mutating func answer(set answer: Bool?)
}
