//
//  GlobalChanging.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/06/21.
//

import Foundation

/// Отвечает за все свойства, которые могут быть использованы для редактирования базы данных
class GlobalChanging: ObservableObject {
    @Published var wordToChange: WordModel?
}
