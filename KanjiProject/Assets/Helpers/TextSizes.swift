//
//  TextSizes.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/01/13.
//

import Foundation

/// Размер текста в приложении
final class TextSizes {
    /// Размер кандзи в примерах и чтениях
    /// - parameter body: Тело
    /// - parameter furigana: Чтение
    /// - parameter schoolLevel: Размер метки уровня [高] и тп.
    static let kanji: (body: CGFloat, furigana: CGFloat, schoolLevel: CGFloat) = (30, 15, 25)

    /// Размер ・ между словами в примерах
    /// - parameter circle: Размер точки
    /// - parameter space: Размер отступа справа и слева от точки
    static let divider: (circle: CGFloat, space: CGFloat) = (6, 5)

    /// Рамер большого кандзи, отображаемого вместе с ключем аналогичного размера
    static let kanjiSize: CGFloat = 100
    
    /// Перевод, метка языка отображаемая в кандзи
    static let translation: (tag: CGFloat, meaning: CGFloat) = (20, 25)
    
    // MARK: Убрать вместе с KanjiCheckView
    static let bottomButtonsText: CGFloat = 30
    
    /// Отвечает за нижний TextEditor в EditWordView
    static let wordEdit: CGFloat = 25
    
    // MARK: используются в CheckWordsView и будут убраны после завершения работы со словами. (ВОЗМОЖНО)
    static func kanjiSize(_ size: CGFloat, _ multiplier: CGFloat = 1.5) -> CGFloat {
        size / 15 / multiplier
    }
    
    static func furiganaSize(_ size: CGFloat, _ multiplier: CGFloat = 1.5) -> CGFloat {
        kanjiSize(size, multiplier) * ElementSize.furiganaPropotions
    }
}
