//
//  GlobalChanging.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/06/21.
//

import SwiftUI

/// Отвечает за все свойства, которые могут быть использованы для редактирования базы данных
final class GlobalChanging: ObservableObject {
    @Published var wordToChange: WordModel? {
        didSet {
            if lastSelectedWord?.id != wordToChange?.id {
                lastSelectedWord = wordToChange
            }
        }
    }
    @Published private var lastSelectedWord: WordModel?
    @FocusState var keybordKeayFocusState: Bool
    
    func wordWasChanged() -> Bool {
        wordToChange == lastSelectedWord ? false : true
    }
}
