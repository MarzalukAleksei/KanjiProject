//
//  ScrollPartsModifires.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/04.
//

import SwiftUI

struct ScrollMainWoodPartModifier: ViewModifier {
    let width: CGFloat
    let corners: UIRectCorner
    func body(content: Content) -> some View {
        content
            .frame(width: width / 2.5, height: PartsSize.woodPartHeight)
            .clipShape(PartialRoundedRectangle(cornerRadius: 5, corners: corners))
    }
}

struct OpenScrollParticalRoundedModifier: ViewModifier {
    let cornerRadius: CGFloat
    let corners: UIRectCorner
    func body(content: Content) -> some View {
        content
            .clipShape(PartialRoundedRectangle(cornerRadius: cornerRadius, corners: corners))
    }
}

struct ScrollLittleWoodPartModifier: ViewModifier {
    let corners: UIRectCorner
    func body(content: Content) -> some View {
        content
            .frame(width: PartsSize.litleWoodPartSize.width, height: PartsSize.litleWoodPartSize.height)
            .clipShape(PartialRoundedRectangle(cornerRadius: 2.5, corners: corners))
    }
}

struct ScrollBodyBodifier: ViewModifier {
    let size: CGSize
//    let corners: UIRectCorner
    func body(content: Content) -> some View {
        content
            .frame(width: size.width, height: size.height)
//            .clipShape(PartialRoundedRectangle(cornerRadius: size.width / 5, corners: corners))
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
    let rotaion: CGFloat
    func body(content: Content) -> some View {
        content
            .frame(width: width / 2.5, height: PartsSize.woodPartHeight)
            .clipShape(PartialRoundedRectangle(cornerRadius: width / 9,
                                               corners: [.topLeft,
                                                         .topRight]).rotation(.degrees(rotaion)))
            .rotationEffect(.degrees(90))
            .frame(width: PartsSize.woodPartHeight, height: width / 2.5)
    }
}
