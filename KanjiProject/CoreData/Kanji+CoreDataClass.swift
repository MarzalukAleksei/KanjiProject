//
//  Kanji+CoreDataClass.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/02.
//
//

import SwiftUI
import CoreData

@objc(Kanji)
public class Kanji: NSManagedObject {

    static func transformToKanjiModel(kanji: FetchedResults<Kanji>, _ level: Level) -> [KanjiModel] {
        let result = kanji.filter { $0.level == level.rawValue }.map { data in
            KanjiModel(body: data.body,
                       kun: data.kun,
                       on: data.on,
                       translate: data.translate,
                       number: data.number,
                       level: data.level,
                       examples: data.examples ?? [],
                       rightAnwers: data.rightAnswers,
                       wrongAnswers: data.wrongAnswers)
        }
        
        return result
    }
    
    static func transformAll(kanji: FetchedResults<Kanji>) -> [KanjiModel] {
        let result = kanji.map { data in
            KanjiModel(body: data.body,
                       kun: data.kun,
                       on: data.on,
                       translate: data.translate,
                       number: data.number,
                       level: data.level,
                       examples: data.examples ?? [],
                       rightAnwers: data.rightAnswers,
                       wrongAnswers: data.wrongAnswers,
                       lastAnswerRight: data.lastAnswerRight)
        }
        return result
    }
}
