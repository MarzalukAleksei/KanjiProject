//
//  KanjiTranslateMapper.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/06/07.
//

import Foundation

class KanjiTranslateMapper: IDataMapper {
    typealias Result = [(kanjiBody: String, meaning: String)]
    
    typealias Entity = [String]
    
    func gettingData(entity: [String]) -> [(kanjiBody: String, meaning: String)] {
        var result: [(kanjiBody: String, meaning: String)] = []
        for row in entity {
            guard let index = row.firstIndex(of: "-") else { continue }
            let afterIndex = row.index(index, offsetBy: 2)
            let meaning = String(row[afterIndex..<row.endIndex])
            result.append((String(row.first ?? "E"), meaning))
        }
        return result
    }
    
    func update(in store: Store) {
        do {
           let translates = KanjiTranslateMapper().gettingData(entity: FileMapper().transform(data: try FileManage().loadFile(fileName: "kanjiN1Translate", fileType: .txt)))
            for kanji in store.kanjiKankenStore.getAll() {
                for translate in translates where translate.kanjiBody == kanji.body {
                    var kanji = kanji
                    kanji.meaningInRussion = translate.meaning
                    store.kanjiKankenStore.update(set: kanji)
                }
            }
            Task {
                await store.kanjiKankenStore.saveInFileManager()
            }
        } catch {
            print("FileNotExist")
        }
    }
    
    
    
}
