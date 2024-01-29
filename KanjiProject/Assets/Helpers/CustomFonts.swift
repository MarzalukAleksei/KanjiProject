//
//  Fonts.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/22.
//

import Foundation
import SwiftUI

class CustomFont {
    static var cardMainKanji: Font {
        Font.system(size: 70)
    }
    
    static func background(size: CGFloat) -> Font {
        return Font.custom("ZeroGothic", size: size)
    }
    
    static func scroll(size: CGFloat) -> Font {
        return Font.custom("UNAO-JAPON-pro--new--", size: size)
    }
    
    static func main(size: CGFloat) -> Font {
        return Font.custom("NotoSerifJP-Regular", size: size)
    }
}


