//
//  UserSettings.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/10/12.
//

import Foundation

//@available(iOS 17.0, *)
//@Observable
class UserSettings: ObservableObject {
    @Published var countOfNewElementsToList: Int = 20
}
