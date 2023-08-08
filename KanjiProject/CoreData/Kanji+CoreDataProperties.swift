//
//  Kanji+CoreDataProperties.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/02.
//
//

import Foundation
import CoreData


extension Kanji {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Kanji> {
        return NSFetchRequest<Kanji>(entityName: "Kanji")
    }
    
    @NSManaged public var body: String
    @NSManaged public var kun: String
    @NSManaged public var on: String
    @NSManaged public var translate: String
    @NSManaged public var level: Int
    @NSManaged public var examples: [String]?
    @NSManaged public var number: Int
    @NSManaged public var rightAnswers: Int
    @NSManaged public var wrongAnswers: Int
    @NSManaged public var lastAnswerRight: Bool
    
}

extension Kanji : Identifiable {
    
}
