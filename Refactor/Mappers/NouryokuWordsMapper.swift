//
//  NouryokuWordsMapper.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/10/31.
//

import Foundation

class NouryokuWordsMapper: IDataMapper {
    typealias Result = [NouryokuWord]
    
    typealias Entity = [String]
    
    func gettingData(entity: [String]) -> [NouryokuWord] {
        var result: [NouryokuWord] = []
        var entity = entity
        entity.removeFirst()
        
        for row in entity {
            let ar = row.components(separatedBy: "\t")
            let oldLevel = Int(ar[1]) ?? 0
            let word = NouryokuWord(body: ar[3], reading: ar[0], oldLevel: oldLevel, origin: ar[4])
            result.append(word)
        }
        
        return result.map(exchange)
    }
    
    func anotherGettingData(entity: [String]) -> [NouryokuWord] {
        var result: [NouryokuWord] = []
        let entity = entity[0].components(separatedBy: "\n")
        for row in entity where row != "" {
            let ar = row.components(separatedBy: "\t")
            let word = NouryokuWord(body: ar[0], reading: ar[1], oldLevel: 0, origin: "", transtale: ar[2])
            result.append(word)
        }
        
        return result
    }
    
    func exchange(word: NouryokuWord) -> NouryokuWord {
        let letters = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM"
        var word = word
        for char in word.body where letters.contains(char) {
            word.inEnglish = word.body
            word.body = word.reading
            word.reading = ""
            break
        }
        return word
    }
}
