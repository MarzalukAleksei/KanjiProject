//
//  IFileManager.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/02.
//

protocol IFileManager {
    associatedtype FileType
    
    func loadFile(fileName: String, fileType: FileType) throws -> String
}
