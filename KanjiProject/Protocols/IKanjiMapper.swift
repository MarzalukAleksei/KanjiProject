//
//  IKanjiMapper.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/02.
//

import Foundation

protocol IKanjiMapper {
    associatedtype Result
    associatedtype Entity
    
    func gettingData(entity: Entity) -> Result
    
}
