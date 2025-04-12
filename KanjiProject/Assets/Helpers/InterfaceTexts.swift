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
    
    /// Текст сообщения на KanjiView
    static func infoAlertOnMainViewJLPT(_ numberOf: Int) -> String {
        "На экзамене JLPT используются кандзи входящие в список 常用漢字 (кандзи для повседневного использования). Всего их \(numberOf). Разделение на уровни относительно, поэтому нередко в тексте можно встретить кандзи уровнем выше чем текущий."
    }
    static func infoAlertOnMainViewKanken(_ numberOf: Int) -> String {
        "Содержит \(numberOf) кандзи. До 2 уровня включительно, входят в японскую школьную программу."
    }
    static let infoAlertButtonOnMainview = "Понятно!"
    
    static func keyPesentaionStyle(_ key: BushuModel, _ showVariats: Bool) -> AttributedString {
        let bodyName = "\(key.body) (\(key.name))"
        let point = showVariats ? ", так же может иметь написание " : "."
//        let alsoWrite = showVariats ? "так же может иметь написание " : ""
        
        let attributedString = AttributedString("Ключ \(bodyName)\(point)")
        
        return keyPresentation(attributedString, key, showVariats)
    }
    
}

extension InterfaceTexts {
    private static func keyPresentation(_ attributedString: AttributedString, _ key: BushuModel, _ showVar: Bool) -> AttributedString {
        var attributedString = attributedString
        let variants = key.variant.components(separatedBy: ",")
        if showVar {
            variants.forEach { comp in
                attributedString.append(AttributedString(comp))
                comp != variants.last ? attributedString.append(AttributedString(", ")) : attributedString.append(AttributedString("."))
            }
        }
        let nameRange = attributedString.range(of: key.name)
        let bodyRange = attributedString.range(of: key.body)
        
        guard let nameRange, let bodyRange else { return attributedString }
        attributedString[bodyRange].foregroundColor = .red
        attributedString[bodyRange].font = .largeTitle
        attributedString[nameRange].foregroundColor = .red
        
        for variant in variants {
            guard let variantRange = attributedString.range(of: variant) else { return attributedString }
            attributedString[variantRange].foregroundColor = .red
            attributedString[variantRange].font = .largeTitle
        }
        return attributedString
    }
}
