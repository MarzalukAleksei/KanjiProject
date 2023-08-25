//
//  Modifiers.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/10.
//

import SwiftUI

class Modifiers {
    static let cardView = CardViewModifire()
    
    static let learningRect = LearningNavigarionBarRectModifier()
    
    static let tabBarSize = TabBarsizeModifier()
    
    static let learningCell = LearningCellModifier()
    
    static let roundedRectTopRightBlackPart = RoundedRectWithBlackPartModifier(corner: .topRight)
    
    static let roundedRectTopLeftBlackPart = RoundedRectWithBlackPartModifier(corner: .topLeft)
    
    static let userButton = UserListButtonModifier()
}

struct TabBarsizeModifier: ViewModifier {
    let padding = Settings.padding
    let imageHeigt = Settings.tabBarImageSize.height
    let imageWidth = Settings.tabBarImageSize.width
    let extra: CGFloat
    
    init() {
        self.extra = imageHeigt - imageWidth
    }
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: imageHeigt + padding + padding)
    }
}

struct CardViewModifire: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(20)
            .foregroundColor(.gray)
    }
}

struct LearningNavigarionBarRectModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(Settings.learningViewCornerRadius)
            .foregroundColor(.white)
            .padding(.horizontal, Settings.padding)
            .padding(.bottom, Settings.padding)
    }
}

struct LearningCellModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(minHeight: PartsSize.learningCellHeight)
            .padding(1)
    }
}

struct RoundedRectWithBlackPartModifier: ViewModifier {
    let corner: UIRectCorner
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: PartsSize.customtoggleSize.height + (Settings.padding * 2))
            .clipShape(PartialRoundedRectangle(cornerRadius: PartsSize.navigationCornerRadius, corners: corner))
            .background(Color.black)
            .foregroundColor(.white)
    }
}

struct UserListButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: PartsSize.learningCellHeight)
            .foregroundColor(.white)
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: Settings.dinamicResaiseblePartsCornerRadius))
    }
}
