//
//  DatabaseOptions.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/09/25.
//

import Foundation

/// Содержит базовые константные значения
class DatabaseOptions {
    static let minutesPassedFirst = 60 * 24 * 3 // 3 days later
    
    static let minutesPassedSecond = 60 * 24 * 5 // 5 days later
    
    static let minutesPassedThird = 60 * 24 * 10 // 10 days later
    
    static let answersInRowFirst = 5
    
    static let answersInRowSecond = 10
    
    static let answersInRowThird = 15
    
    static let maxLearningElementsCountBasicValue = 20
    
    static let newKanjiInDayConstantValue = 0
    
    static let newWordsInDayConstantValue = 0
}
