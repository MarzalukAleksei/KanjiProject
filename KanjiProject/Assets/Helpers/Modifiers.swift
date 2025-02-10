//
//  Modifiers.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/10.
//

import SwiftUI

final class Modifiers {
    static let cardView = CardViewModifire()
    
    static let learningRect = LearningNavigarionBarRectModifier()
    
    static let tabBarSize = TabBarsizeModifier()
    
    static let learningCell = LearningCellModifier()
    
    static let roundedRectTopRightBlackPart = RoundedRectWithBlackPartModifier(corner: .topRight)
    
    static let roundedRectTopLeftBlackPart = RoundedRectWithBlackPartModifier(corner: .topLeft)
    
    static let userButton = UserListButtonModifier()
    
    static let chevron = NavigationChevronModifier()
    
    static let edittingButton = EdittingButtonModifier()
    
    static let trashButton = TrashButtonModifier()
    
    static let rightAnswerButton = ButtonModifier(color: ElementsColors.answerButton.right,
                                                        height: ElementSize.bottomButtonImage.height * 2 + Settings.padding)
    
    static let wrongAnswerButton = ButtonModifier(color: ElementsColors.answerButton.wrong,
                                                 height: ElementSize.bottomButtonImage.height * 2 + Settings.padding)
    
    static let inListButton = ButtonModifier(color: ElementsColors.inListButton,
                                                   height: ElementSize.bottomButtonImage.height + Settings.padding)
    
    static let skipButton = ButtonModifier(color: ElementsColors.skipButton,
                                                 height: ElementSize.bottomButtonImage.height + Settings.padding)
    
    static let editWordButton = ButtonModifier(color: Color.clear,
                                              height: ElementSize.closeButton.height,
                                              width: ElementSize.closeButton.width)
    
    static let mainKanji = Kanjimodifier()
    
    static let keyModalViewText = KeyModalViewTextModifiers()
    
    static let customSlider = CustomSlidermodifier()
}

struct CustomSlidermodifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: ElementSize.customtoggleSize.width,
                   height: ElementSize.customtoggleSize.height)
    }
}

struct Kanjimodifier: ViewModifier {
    func body(content: Content) -> some View {
        content
        .font(.system(size: TextSizes.kanjiSize))
        .foregroundStyle(Color.black)
        .padding(.horizontal, TextSizes.kanjiSize * 0.3 / 2)
        .border(Color.black, width: 1)
        .padding(.leading, Settings.padding)
    }
}

struct KeyModalViewTextModifiers: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ButtonModifier: ViewModifier {
    let color: Color
    let height: CGFloat
    let width: CGFloat
    
    init(color: Color, height: CGFloat, width: CGFloat = .infinity) {
        self.color = color
        self.height = height
        self.width = width
    }
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: width, maxHeight: height)
            .foregroundStyle(.black)
            .background {
                color
                    .ignoresSafeArea()
            }
    }
}

struct TabBarsizeModifier: ViewModifier {
    let padding = Settings.padding
    let imageHeigt = Settings.tabBarButtonImageSize.height 
    let imageWidth = Settings.tabBarButtonImageSize.width
//    let extra: CGFloat
//    
//    init() {
//        self.extra = imageHeigt - imageWidth
//    }
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: imageHeigt + padding + padding)
    }
}

struct CardViewModifire: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(Settings.cornerRadius)
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
            .frame(minHeight: ElementSize.learningCellHeight)
            .padding(1)
    }
}

struct RoundedRectWithBlackPartModifier: ViewModifier {
    let corner: UIRectCorner
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: ElementSize.customtoggleSize.height + (Settings.padding * 2))
            .clipShape(PartialRoundedRectangle(cornerRadius: ElementSize.navigationCornerRadius, corners: corner))
            .background(Color.black)
            .foregroundColor(.white)
    }
}

struct UserListButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: ElementSize.learningCellHeight)
            .foregroundColor(.white)
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: Settings.dinamicResaiseblePartsCornerRadius))
    }
    
}

struct NavigationChevronModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: ElementSize.dismissButtonShevronSize.width,
                   height: ElementSize.dismissButtonShevronSize.height)
            .padding(Settings.padding)
    }
}

struct EdittingButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: -90))
            .frame(width: ElementSize.edittingButtonSise.height, height: ElementSize.edittingButtonSise.width) // из-за ротации ширина - это высота и наоборот
    }
}

struct TrashButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: ElementSize.edittingButtonSise.width, height: ElementSize.edittingButtonSise.height)
    }
}

struct NavigationBarColor: ViewModifier {
    init(backgroundColor: UIColor?, tintColor: UIColor?) {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = backgroundColor
        coloredAppearance.titleTextAttributes = [.foregroundColor: tintColor ?? UIColor.white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: tintColor ?? UIColor.white]

        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = tintColor ?? UIColor.white
    }

    func body(content: Content) -> some View {
        content
    }
}
