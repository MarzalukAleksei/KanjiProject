//
//  BushuMapper.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/05/27.
//

import Foundation

class BushuMapper: IDataMapper {
    
    typealias Result = [BushuModel]
    
    typealias Entity = [String]
    
    func gettingData(entity: [String]) -> [BushuModel] {
        var result: [BushuModel] = []
        var entity = entity
        entity.removeFirst()
        
        for element in entity.enumerated() {
            var row = element.element.components(separatedBy: ",")
            row = row.map { element in
                var element = element
                element = element.replacingOccurrences(of: "\"", with: "")
                return element.replacingOccurrences(of: "@@@", with: ",")
            }
            
            let id = element.offset + 1
            let body = row[0]
            let meaning = row[1]
            let name = row[2]
            let varian = row[3]
            let explanation = row[4]
            let oftenUsed = row[5].contains("+") ? false : true
            
            result.append(.init(id: id,
                                body: body,
                                meaning: meaning,
                                name: name,
                                variant: varian,
                                explanation: explanation,
                                oftenUsed: oftenUsed))
            
        }
        
        return result
    }
    
}
