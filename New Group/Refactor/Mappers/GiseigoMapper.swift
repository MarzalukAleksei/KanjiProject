//
//  GiseigoMapper.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/09/13.
//

import Foundation

class GiseigoMapper: IDataMapper {
    typealias Result = [GiseigoModel]
    typealias Entity = [String]
    
    func gettingData(entity: [String]) -> [GiseigoModel] {
        var result: [GiseigoModel] = []
        
        var entity = entity
        entity.removeFirst()
        
        for row in entity {
            let elements = row.components(separatedBy: ",")
            let giseigo = GiseigoModel(word: elements[0],
                                       examples: elements[1].components(separatedBy: "・"),
                                       role: elements[2].components(separatedBy: "・"),
                                       wordTranslate: elements[3].replacingOccurrences(of: "; ", with: ";").components(separatedBy: ";"),
                                       examplesTranslate: elements[4].replacingOccurrences(of: "; ", with: ";").components(separatedBy: ";"),
                                       sameWords: elements[5].components(separatedBy: "・"),
                                       root: elements[6].components(separatedBy: "・"),
                                       difficulty: Int(elements[7]) ?? 0,
                                       learned: false)
            result.append(giseigo)
        }
        
        return result
    }
    
}
