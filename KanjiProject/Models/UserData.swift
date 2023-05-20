//
//  UserData.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/15.
//

import Foundation

struct UserData {
    
    enum Level: String {
        case N1, N2, N3, N4, N5, beginer
    }
    
    var level: Level
    var dictionary: [KanjiModel]
}
