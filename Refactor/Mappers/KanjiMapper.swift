//
//  KanjiMapper.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/02.
//

import Foundation

class KanjiMapper: IDataMapper {
    typealias Result = [KanjiModel]
    typealias Entity = [String]
    
    func gettingData(entity: [String]) -> [KanjiModel] {
        var result: [KanjiModel] = []
        
        var entity = entity
        entity.removeFirst()
        
        for row in entity {
            let elements = row.components(separatedBy: ",")
            let body = elements[0]
            let translate = elements[1]
            let on = elements[2]
            let kun = elements[3]
            let number = Int(elements[4]) ?? 0
            let level = Int(elements[5]) ?? 0
            result.append(KanjiModel(body: body, kun: kun, on: on, translate: translate, number: number, level: level))
        }
        
        return result
    }
}
