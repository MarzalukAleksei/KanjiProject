//
//  NyarsDatabaseModel.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2025/03/26.
//

import Foundation

struct NyarsDatabaseModel: Codable, Identifiable {
    let id: UUID
    private let wid: String
    private let isUnreviewed: Bool
    private let isUnconfirmed: Bool
    private let isArchaic: Bool
    private let isProper: Bool
    private let isDeleted: Bool
    private let rank: Int
    private let length: Int
    private let needUpdate: Bool
    private let createdAt: String
    private let updatedAt: String
    private let entryJP: Entry
    
    var words: [String] {
        getWords()
    }
    
    var readings: [String] {
        getReadings()
    }
    
    var readingsInKana: [String] {
        getReadings().map(transformToKana)
    }
    
    var translates: [String] {
        getTranslates()
    }
}

extension NyarsDatabaseModel {
    private enum CodingKeys: String, CodingKey {
        case id = "Id"
        case wid = "Wid"
        case rank = "Rank"
        case length = "Length"
        case entryJP = "EntryJp"
        case isUnreviewed
        case isUnconfirmed
        case isArchaic
        case isProper
        case isDeleted
        case needUpdate = "NeedUpdate"
        case createdAt = "CreatedAt"
        case updatedAt = "UpdatedAt"
    }
    
    private func getWords() -> [String] {
        guard let words = entryJP.words else { return [] }
        
        var result: [String] = []
        for word in words {
            guard let spellings = word.spellings else { return getReadings().map(transformToKana) }
            for spelling in spellings {
                result.append(spelling.value)
            }
        }
        
        return result
    }
    
    private func getReadings() -> [String] {
        guard let words = entryJP.words else { return [] }
        var result: [String] = []
        for word in words {
            guard let readings = word.readings else { continue }
            for reading in readings {
                result.append(reading.value)
            }
        }
        return result
    }
    
    private func getTranslates() -> [String] {
        var result: [String] = []
        guard let meanings = entryJP.meanings else { return [] }
        
        for meaning in meanings {
            guard let senses = meaning.senses else { continue }
            for sense in senses {
                result.append(rows(sense.content))
            }
        }
        
        return result
    }
    
    private func transformToKana(_ string: String) -> String {
        var result = ""
        var isKatakana = false
        var toTransform = ""
        
        for char in string {
            if char == "!" {
                result += transform(isKatakana, row: toTransform)
                isKatakana.toggle()
                toTransform = ""
                continue
            }
            toTransform.append(char)
        }
        result += transform(isKatakana, row: toTransform)
        
        return result
    }
    
    private func transform(_ isKatakana: Bool, row: String) -> String {
        switch isKatakana {
        case true:
            return romajiToKatakana(row)
        case false:
            return romajiToHiragana(row)
        }
    }
    
    private func romajiToHiragana(_ romaji: String) -> String {
        var romaji = romaji
        romaji = romaji.replacingOccurrences(of: ":", with: "u")
        let text = NSMutableString(string: romaji)
        CFStringTransform(text, nil, kCFStringTransformLatinHiragana, false)
        var result = text as String
        for check in ["な", "に", "ぬ", "ね", "の"] {
            result = result.replacingOccurrences(of: "っ\(check)", with: "ん\(check)")
        }
        return result
    }
    
    private func romajiToKatakana(_ romaji: String) -> String {
        var romaji = romaji
        romaji = romaji.replacingOccurrences(of: ":", with: "ー")
        let text = NSMutableString(string: romaji)
        CFStringTransform(text, nil, kCFStringTransformLatinKatakana, false)
        var result = text as String
        for check in ["ナ", "ニ", "ヌ", "ネ", "ノ"] {
            result = result.replacingOccurrences(of: "ッ\(check)", with: "ン\(check)")
        }
        return result
    }
    
    private func rows(_ content: [Rows]?) -> String {
        var result = ""
        guard let content = content else { return result }
        for part in content {
            if part.v != "\\" {
                result += part.v
            }
            if part.c != nil {
                result += rows(part.c)
            }
        }
        return result
    }
}

private struct Entry: Codable {
    let words: [Word]?
    let meanings: [Meaning]?
}

private struct Word: Codable {
    let spellings: [Spelling]?
    let readings: [Reading]?
}

private struct Spelling: Codable {
    let value: String
}

private struct Reading: Codable {
    let value: String
    let pitch: [String]?
}

private struct Meaning: Codable {
    let tags: [Int]?
    let senses: [Sense]?
}

private struct Sense: Codable {
    let content: [Rows]?
}

private struct Rows: Codable {
    let v: String
    let c: [Rows]?
//    let t: String
}


