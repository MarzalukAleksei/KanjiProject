//
//  IKanjiStore.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/12.
//

import Foundation

protocol IStore {
    associatedtype Result
    associatedtype Entity
    
    func update(data: Entity)
    func getData() -> Result
    func clearAll()
}
