//
//  Modifiers.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/10.
//

import SwiftUI

class Modifiers {
    static let cardViewModifier = CardViewModifire()
}


struct CardViewModifire: ViewModifier {
    func body(content: Content) -> some View {
        content
        .cornerRadius(20)
        .foregroundColor(.gray)
    }
}
