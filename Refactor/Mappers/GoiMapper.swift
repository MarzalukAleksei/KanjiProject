//
//  GoiMApper.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/07/12.
//

import Foundation

class GoiMapper: IDataMapper {
    
    func gettingData(entity: [String]) -> [WordModel] {
        return words(entity: entity)
    }
    
    func gettingData(entity: [String], level: NouryokuLevel) -> [WordModel] {
        return words(entity: entity, level: level)
    }
    
    private func words(entity: [String], level: NouryokuLevel = .another) -> [WordModel] {
        var result: [WordModel] = []
        var entity = entity
        entity.removeFirst()
        
        for row in entity {
            let parts = row.components(separatedBy: ",")
            let body = parts[0]
            let inEnglish = parts[2].replacingOccurrences(of: "/", with: ",")
//            let word = WordModel(id: id,
//                                 body: body,
//                                 meaningInEnglish: inEnglish,
//                                 meaningInRussian: "",
//                                 reading: "",
//                                 type: "",
//                                 levels: [],
//                                 levelInTag: [level])
            let word = WordModel(body: body, meaningInEnglish: inEnglish, level: level)
            result.append(word)
        }
        return result
    }
}
