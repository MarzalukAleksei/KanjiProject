//
//  YojijukugoModel.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/09/03.
//

import Foundation

struct YojijukugoModel: Codable, Identifiable {
    var id = UUID()
    let body: String
    let reading: String
    let translate: String
    let point: String
}
