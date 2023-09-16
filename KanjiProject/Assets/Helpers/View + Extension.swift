//
//  NavigationView + Extension.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/09/16.
//

import SwiftUI


extension View {
    func navigationBarColor(backgroundColor: UIColor?, tintColor: UIColor?) -> some View {
        self.modifier(NavigationBarColor(backgroundColor: backgroundColor, tintColor: tintColor))
    }
}
