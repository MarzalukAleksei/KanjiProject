//
//  YojijukugoMapper.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/09/03.
//

import Foundation

class YojijukugoMapper: IDataMapper {
    
    typealias Result = [YojijukugoModel]
    
    typealias Entity = [String]
    
    func gettingData(entity: [String]) -> [YojijukugoModel] {
        var result: [YojijukugoModel] = []
        
        var entity = entity
        entity.removeFirst()
        
        for row in entity {
            let elements = row.components(separatedBy: ",")
            let body = elements[0]
            let reading = elements[1]
            let translate = elements[2]
            let point = elements[3]
            result.append(YojijukugoModel(body: body,
                                          reading: reading,
                                          translate: translate,
                                          point: point))
        }
        
        return result
    }
    
}
