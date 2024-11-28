//
//  InterfaceTexts.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/11/13.
//

import Foundation

final class InterfaceTexts {
    static let kanjiViewTitle: String = "漢字を勉強しよう"
    
    static let kanjiKanken = "KANKEN 漢検"
    
    static let kanjiNouryoku = "JLPT 日本語能力試験"
    
    static func infoAlertOnMainViewJLPT(_ numberOf: Int) -> String {
        "Содержит \(numberOf) кандзи, входящих в официальный экзамен."
    }
    static func infoAlertOnMainViewKanken(_ numberOf: Int) -> String {
        "Содержит \(numberOf) кандзи. До 2 уровня включительно, входят в японскую школьную программу и состоит из так называемых 常用漢字 (кандзи для повседневного использования). 1 уровень, как правило, изучается для поступления в университет или по другой причине."
    }
    static let infoAlertButtonOnMainview = "Понятно!"
    
    
}
