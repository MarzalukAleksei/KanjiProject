//
//  FileMapper.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/02.
//

import Foundation

class FileMapper: IFileMapper {
    
    func transform(data: String) -> [String] {
        let str = data.replacingOccurrences(of: "\r", with: "\n")
        let result = str.split(separator: "\n\n").map { String($0) }
        return result
    }
}
