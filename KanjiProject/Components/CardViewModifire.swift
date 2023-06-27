//
//  CardViewModifire.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/06/26.
//

import SwiftUI

struct CardViewModifire: ViewModifier {
    func body(content: Content) -> some View {
        content
        .cornerRadius(20)
        .foregroundColor(.gray)
    }
}
