//
//  IWords.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2025/05/14.
//

import Foundation

protocol IWord {
    associatedtype Word
    
    func update(set word: Word)
    
    func update(set word: Word) async
    
    func add(word: Word)
    
    func delete(_ word: Word) async
    
}
