//
//  IFileMapper.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/02.
//

import Foundation

protocol IFileMapper {
    func transform(data: String) -> [String]
}
