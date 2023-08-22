//
//  FileManager.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/02.
//

import Foundation

class FileManage: IFileManager {
    
    enum FileType: String {
        case txt
        case csv
    }
    
    func loadFile(fileName: String, fileType: FileType) throws -> String {
        guard let string = Bundle.main.path(forResource: fileName, ofType: fileType.rawValue) else {
            return "File not found" }
        do {
            let result = try String(contentsOfFile: string)
            return result
        } catch {
            throw error
        }
    }
    
}
