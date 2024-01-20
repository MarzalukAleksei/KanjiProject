//
//  TextAndReadingModel.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/10/22.
//

import Foundation

struct TextAndReading: Hashable, Codable {
    var text: String
    var reading: String
}

extension TextAndReading {
    func width() -> CGFloat {
        let readingWidth = CGFloat(self.reading.count) * TextSizes.kanjiReading
        let kanjiBodyWidth = CGFloat(self.text.removeAll(after: "（").count) * TextSizes.kanjiBody
        return readingWidth > kanjiBodyWidth ? readingWidth : kanjiBodyWidth
    }
}
