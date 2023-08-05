//
//  ScrollPartsModifires.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/04.
//

import SwiftUI

struct ScrollMainWoodPartModifier: ViewModifier {
    let width: CGFloat
    func body(content: Content) -> some View {
        content
            .frame(width: width / 2.5, height: PartsSize.woodPartHeight)
    }
}

struct ScrollLittleWoodPartModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: PartsSize.litleWoodPartSize.width, height: PartsSize.litleWoodPartSize.height)
    }
}

struct ScrollBodyBodifier: ViewModifier {
    let size: CGSize
    func body(content: Content) -> some View {
        content
            .frame(width: size.width, height: size.height)
//            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct CloseScrollBodyModifier: ViewModifier {
    let size: CGSize
    func body(content: Content) -> some View {
        content
            .frame(width: size.width, height: size.height)
            .rotationEffect(.degrees(90))
            .frame(width: size.height, height: size.width)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct CloseScrollMainWoodPartModifier: ViewModifier {
    let width: CGFloat
    func body(content: Content) -> some View {
        content
            .frame(width: width / 2.5, height: PartsSize.woodPartHeight)
            .rotationEffect(.degrees(90))
            .frame(width: PartsSize.woodPartHeight, height: width / 2.5)
    }
}
