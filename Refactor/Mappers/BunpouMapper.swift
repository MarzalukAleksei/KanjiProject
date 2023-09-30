//
//  BunpouMapper.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/09/27.
//

import Foundation

class BunpouMapper: IDataMapper {
    typealias Result = [BunpouModel]
    
    typealias Entity = [String]
    
    func gettingData(entity: [String]) -> [BunpouModel] {
        var result: [BunpouModel] = []
        
        var entity = entity
        entity.removeFirst()
        
        for row in entity {
            let elements = row.components(separatedBy: ",")
            let bunpou = BunpouModel(body: elements[0],
                                     connections: elements[1].components(separatedBy: "・"),
                                     // убирает "
                                     points: elements[2].components(separatedBy: "・").map { $0.contains("\"") ? $0.replacingOccurrences(of: "\"", with: "") : $0 },
                                     meaning: elements[3].components(separatedBy: "・"),
                                     translate: elements[4].components(separatedBy: "・"),
                                     // убирает пробелы если они есть
                                     examples: elements[5].components(separatedBy: "・").map{ $0.contains(" ") ? $0.replacingOccurrences(of: " ", with: "") : $0 }.map { $0.contains("　") ? $0.replacingOccurrences(of: "　", with: "") : $0 },
                                     level: Level(rawValue: Int(elements[6]) ?? 0) ?? Level.another)
            result.append(bunpou)
        }
        
        return result
    }
    
    
    
    
}
