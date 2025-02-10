//
//  DatabaseOptions.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/09/25.
//

import Foundation

/// Содержит базовые константные значения
final class DatabaseOptions {
    static let passedDays: (first: Int, second: Int, third: Int) = (3, 5, 10)
    
    static let answersCounts: (first: Int, second: Int, third: Int) = (5, 10, 15)
    
    static let maxLearningElementsCountBasicValue = 20
    
    static let newKanjiInDayConstantValue = 0
    
    static let newWordsInDayConstantValue = 0
}
