//
//  TabBarState.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/09/21.
//

import SwiftUI

/// Отвечает за отображение кастомного нижнего навигатора
final class TabBarState: ObservableObject {
    @Published var tabBarIsHidden = false
}
