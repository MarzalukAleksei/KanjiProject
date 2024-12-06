//
//  IFileDataMapper.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/06/22.
//

import Foundation

protocol IDataMapper {
    associatedtype Result
    associatedtype Entity
    
    func gettingData(entity: Entity) -> Result
    
}
