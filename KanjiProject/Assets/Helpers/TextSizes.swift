//
//  TextSizes.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/01/13.
//

import Foundation

final class TextSizes {
    static let kanjiBody: CGFloat = 30
    
    static let kanjiReading: CGFloat = 12
    
    static let dash: CGFloat = 20
    
    static let translate: CGFloat = 20
    
    static let deviderCircle: CGFloat = 6
    
    static let spacingBetweenWords: CGFloat = 5
    
    static let scloolLevelLabel: CGFloat = 25

    static let kanjiSize: CGFloat = 100
    
    static let bottomButtonsText: CGFloat = 30
    
    static let wordEdit: CGFloat = 25
    
    static let learningWordBody: CGFloat = 50
    
    static let learningWordReading: CGFloat = 30
    
    static func kanjiSize(_ size: CGFloat, _ multiplier: CGFloat = 1.5) -> CGFloat {
        size / 15 / multiplier
    }
    
    static func furiganaSize(_ size: CGFloat, _ multiplier: CGFloat = 1.5) -> CGFloat {
        kanjiSize(size, multiplier) * ElementSize.furiganaPropotions
    }
}
