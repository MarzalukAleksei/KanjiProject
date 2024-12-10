//
//  Settings.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/08.
//

import SwiftUI

class Settings {
    static let elementsInRow = 20
    
    static let customToggleViewCornerRadius: CGFloat = 0.2
    
    static let customNavigationBarTitlePadding: CGFloat = 20
    
    static let opacity: CGFloat = 0.3
    
    /// Отступ от края View
    static let padding: CGFloat = 15
    
    static let learningViewCornerRadius: CGFloat = 40
    
    /// Длительность анимации
    ///
    /// Составляет 0.5 секунды
    static let animation = Animation.easeInOut(duration: 0.5)
    
    static let scrollAnimation = Animation.easeInOut(duration: 2)
    
    /// Отступ между елементами интерфейса
    static let paddingBetweenElements: CGFloat = 10
    
    static let tabBarButtonImageSize = CGSize(width: 20, height: 22)
    
    static let dinamicResaiseblePartsCornerRadius: CGFloat = 8
    
    /// Отступ между текстами интерфейса
    static let paddingBetweenText: CGFloat = 5
    
    static let cornerRadius: CGFloat = 20
    
    static let modalViewButtonCornerRadius: CGFloat = 10
    
    static let spacingBetweenIdiomHeaderAndElements: CGFloat = -10
    
    static let progressBarHeight: CGFloat = 7
    
    static let selectedColor: Color = .secondary
    
    static let diselectedColor: Color = .black
    
    static let closeButtonPadding: CGFloat = padding + 10
    
    static let buttonsCornerRadius: CGFloat = 10
    
    static let questionMarkButtonOpacity = 0.5
    
    static let blurEffectValue: CGFloat = 5
    
    /// Колличество строк в UserActivityView
    static let userActivityIndicatorRows = 5
    
    /// CornerRadius для ячеек UserActivityView
    static let userActivityCellCornerRadius: CGFloat = 5
    
    /// Kоличество элементов в UserActivityView
    static let elementsInUserActivityIndicator = 365
    
    static var sectionPadding: CGFloat { return padding * 1.5 }
    
    static var paddingInUserActivity: CGFloat = 4
}
