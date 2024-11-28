//
//  MyErrors.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/02/06.
//

import Foundation

enum MyErrors: String, Error {
    case noWordsLeft
    case nilWord = "Отсутствует слово"
    case wrongBushu = "Нет соответстующего ключа"
}
