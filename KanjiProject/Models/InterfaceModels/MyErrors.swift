//
//  MyErrors.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/02/06.
//

import Foundation

enum MyErrors: String, Error {
    case noWordsLeft
    case wordIsNotAvailable = "Отсутствует слово"
    case wrongBushu = "Нет соответстующего ключа"
    case activityDecodeFaled = "Ошибка декодирования активности"
    case kanjiNotFound = "Не найден кандзи"
    case unicodeNotFound = "Не найден Unicode"
}
