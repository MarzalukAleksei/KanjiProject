//
//  ElementsColors.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/06/16.
//

import SwiftUI

/// Цвета используемые в приложении
class ElementsColors {
    static let levelButtonRightAnswer: Color = .green
    
    static let levelButtonWrongAnswer: Color = .red
    
    static let levelButtonUnknownAnswer: Color = .white
    
    static let inListButton: Color = .cyan.opacity(0.35)
    
    static let skipButton: Color = .green.opacity(0.35)
    
    static let currentKanjiInExample: Color = .red
    
    /// Цвета кнопок ответа
    /// - parameter right: кнопка верного ответа
    /// - parameter wrong: кнопка неверного ответа
    static let answerButton: (right: Color, wrong: Color) = (.init("rightButtonColor").opacity(0.35),
                                                             .red.opacity(0.35))
    
    static let editWordButton: Color = .black
    
    /// Цвета отображаемые в таблице активности
    /// - parameter confirmedAct: Цвет, когда было хоть одно действие
    /// - parameter skippedDay: Цвет, если в данную дату не было никакой активности
    /// - parameter beforeFirstAct: Цвет для всех ячеек до самой первой активности
    static let userActivityColors: (confirmedAct: Color,
                                    skippedDay: Color,
                                    beforeFirstAct: Color) = (
                                        .init(.activeIndicator),
                                        .init(.inactiveIndicator),
                                        .white)
}
