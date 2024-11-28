//
//  PartsSize.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/05.
//

import SwiftUI

class ElementSize {
    static let woodPartHeight: CGFloat = 12
    
    static let litleWoodPartSize: (width: CGFloat, height: CGFloat) = (7, 8)
    
    static let navigationCornerRadius: CGFloat = 60
    
    static let levelButtonSize: CGSize = CGSize(width: 85, height: 85)
    
    static let customNavigationBarHeight: CGFloat = 90
    
    static let customtoggleSize: CGSize = CGSize(width: 60, height: 30)
    
    static let customRowRectangleSize: CGFloat = 80
    
    static let learningViewNavigationBarHeght: CGFloat = 175
    
    static let dismissButtonShevronSize = CGSize(width: 15, height: 25)
    
    static let learningCellHeight: CGFloat = 60
    
    static let wordDetailViewNavigationBarHight: CGFloat = 60
    
    static let edittingButtonSise = CGSize(width: 17, height: 20) 
    
    static let modalViewButtonHeight: CGFloat = 30
    
    static let pencilButtonSize = CGSize(width: 25, height: 25)
    
    static let closeButton = CGSize(width: 35, height: 35)
    
    static let bottomButtonImage = CGSize(width: 40, height: 40)
    
    static func kanjiSize(_ size: CGFloat, _ multiplier: CGFloat = 1.5) -> CGFloat {
        size / 15 / multiplier
    }
    
    static func furiganaSize(_ size: CGFloat, _ multiplier: CGFloat = 1.5) -> CGFloat {
        kanjiSize(size, multiplier) / 1.7
    }
    
    static let questionMarkSize = CGSize(width: 20, height: 20)
}
