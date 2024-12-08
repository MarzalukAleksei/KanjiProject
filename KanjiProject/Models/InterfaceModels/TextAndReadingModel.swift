//
//  TextAndReadingModel.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/10/22.
//

import Foundation

struct TextAndReading: Identifiable, Hashable, Codable {
    var id = UUID()
    var text: String
    var reading: String
    var wasDivided: Bool?
    
    init(id: UUID = UUID(), text: String, reading: String, wasDivided: Bool? = nil) {
        self.id = id
        self.text = text
        self.reading = reading
        self.wasDivided = wasDivided
    }
}

extension TextAndReading {
    func width(kanjiReading: CGFloat = TextSizes.kanjiReading, kanjiBody: CGFloat = TextSizes.kanjiBody) -> CGFloat {
        let readingWidth = CGFloat(self.reading.count) * kanjiReading/* * 0.945*/
        let kanjiBodyWidth = CGFloat(self.text.removeAll(after: "（").count) * kanjiBody/* * 0.945*/
        return readingWidth > kanjiBodyWidth ? readingWidth : kanjiBodyWidth
    }
    mutating func devided() {
        wasDivided = true
    }
}

extension TextAndReading {
    
//    init() {
//        self.text = ""
//        self.reading = ""
//    }
    
    static func setTRArray(_ word: WordModel) -> [TextAndReading] {
        var result: [TextAndReading] = []
        var str = word.reading
        str = str.replacingOccurrences(of: "(", with: "[")
        str = str.replacingOccurrences(of: ")", with: "]")
        if !str.contains("[") {
            str = createOkurigana(word)
        }
        let components = str.components(separatedBy: "]")
        
        for part in components where part != "" {
            let res = part.components(separatedBy: "[")
            if res.count > 1 {
                result.append(TextAndReading(text: res[0], reading: res[1]))
            } else {
                result.append(TextAndReading(text: res[0], reading: ""))
            }
        }
        return result
    }
    
    private static func createOkurigana(_ word: WordModel) -> String {
        var result = "]"
        var reading = word.reading
        let body = word.body
        for bodyChar in body.reversed() {
            if bodyChar == reading.last {
                result.append(String(bodyChar))
                reading.removeLast()
            } else if !result.contains("["), bodyChar != reading.last {
                result.append("[")
                let reading = String(reading.reversed())
                result.append(reading)
                break
            }
        }
       
        return String(result.reversed())
    }
}
