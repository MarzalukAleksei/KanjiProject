//
//  IStore.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/12.
//

import Foundation

protocol IStore {
    associatedtype Result
    associatedtype Entity
    
//    func update(data: Entity)
//    func getData() -> Result
//    func update(_ level: Level, data: Entity)
    func updateAll(data: Entity)
//    func getData(_ level: Level) -> Result
    func getAll() -> Result
    func clearAll()
}
