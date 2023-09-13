//
//  KanaMapper.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/24.
//

import Foundation

class KanaMapper: IDataMapper {
    
    typealias Result = [KanaModel]
    
    typealias Entity = [String]
    
    func gettingData(entity: [String]) -> [KanaModel] {
        var result: [KanaModel] = []
        
        var entity = entity
        entity.removeFirst()
        
        for row in entity {
            let elements = row.components(separatedBy: ",")
            result.append(KanaModel(hiragana: elements[0],
                                    katakana: elements[5],
                                    yaCombination: elements[1],
                                    yuCombination: elements[2],
                                    yoCombination: elements[3],
                                    reading: elements[6]))
        }
        
        return result
    }
    
}
