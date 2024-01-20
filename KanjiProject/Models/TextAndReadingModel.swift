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
}

extension TextAndReading {
    func width() -> CGFloat {
        let readingWidth = CGFloat(self.reading.count) * TextSizes.kanjiReading * 0.945
        let kanjiBodyWidth = CGFloat(self.text.removeAll(after: "（").count) * TextSizes.kanjiBody * 0.945
        return readingWidth > kanjiBodyWidth ? readingWidth : kanjiBodyWidth
    }
}
