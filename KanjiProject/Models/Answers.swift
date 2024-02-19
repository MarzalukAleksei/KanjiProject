//
//  Answers.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/02/17.
//

import Foundation

enum Answers {
    case visible(rightAnswers: Int, wrongAnswers: Int)
    case invisible(rightAnswers: Int, wrongAnswers: Int)
    
    /// Methood that set answer value
    /// - Parameter answerWasRight: If true: rightAnswer += 1; If false: wrongAnswer += 1. oposit value not change.
    mutating func setAnswer(_ answerWasRight: Bool) {
        let rightAnswer = answerWasRight ? 1 : 0
        let wrongAnswer = answerWasRight ? 0 : 1
        
        switch self {
        case .visible(let right, let wrong):
           self = .visible(rightAnswers: right + rightAnswer, wrongAnswers: wrong + wrongAnswer)
        case .invisible(let right, let wrong):
           self = .invisible(rightAnswers: right + rightAnswer, wrongAnswers: wrong + wrongAnswer)
        }
    }
    
    /// Exchange visible and invisible. For example, if you dont need some object anymore, just exchange it to invisible. that it. Also saves answers value.
    mutating func exchange() {
        switch self {
        case .visible(rightAnswers: let rightAnswers, wrongAnswers: let wrongAnswers):
            self = .invisible(rightAnswers: rightAnswers, wrongAnswers: wrongAnswers)
        case .invisible(rightAnswers: let rightAnswers, wrongAnswers: let wrongAnswers):
            self = .visible(rightAnswers: rightAnswers, wrongAnswers: wrongAnswers)
        }
    }
    
    /// Return tupple of answers
    func answers() -> (rightAnswers: Int, wrongAnswers: Int) {
        switch self {
        case .visible(rightAnswers: let rightAnswers, wrongAnswers: let wrongAnswers):
            (rightAnswers, wrongAnswers)
        case .invisible(rightAnswers: let rightAnswers, wrongAnswers: let wrongAnswers):
            (rightAnswers, wrongAnswers)
        }
    }
}

