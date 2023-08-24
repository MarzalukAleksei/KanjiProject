//
//  IKanaMapper.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/24.
//

import Foundation

protocol IKanaMapper {
    associatedtype Result
    associatedtype Entity
    
    func gettingData(entity: Entity) -> Result
    
}
