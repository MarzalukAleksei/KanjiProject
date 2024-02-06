//
//  WordMapper.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/02/06.
//

import Foundation

class WordMapper: IDataMapper {
    
    typealias Result = [WordModel]
    typealias Entity = [String]
    
    func gettingData(entity: [String]) -> [WordModel] {
        var result: [WordModel] = []
        var entity = entity[0].components(separatedBy: "\n")
        
        for row in entity {
            let components = row.components(separatedBy: "\t")
//            print(components)
//            print("")
            result.append(WordModel(body: components[0],
                                    meaningInEnglish: components[1],
                                    meaningInRussian: "",
                                    reading: components[2],
                                    type: components[3],
                                    levels: levels(components[6]), 
                                    levelInTag: levelsInTag(components[6])))
        }
        
        return result
    }
    
    func levels(_ row: String) -> [String] {
        let levels = row.components(separatedBy: " ")
        return levels
    }
    
    func levelsInTag(_ row: String) -> [NouryokuLevel] {
        var result: [NouryokuLevel] = []

        let levels = levels(row)
        for level in levels {
            
            for nouryoku in NouryokuLevel.allCases where nouryoku != .another {
                if level == "jlpt-n\(nouryoku.rawValue)" {
                    result.append(nouryoku)
                }
            }
            
        }
        
        return result
    }
}
