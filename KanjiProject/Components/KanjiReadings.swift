//
//  KanjiReadings.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/06/29.
//

import SwiftUI

struct KanjiReadings: View {
    let currentKanji: KanjiKankenModel
    @Binding var hideKanjiReadings: Bool
    var body: some View {
        VStack(spacing: Settings.paddingBetweenText) {
            Divider()
            
            Divider()
            
            Group {
                ForEach(SchoolLevel.allCases, id: \.self) { type in
                    if let row = getKunReading(type), type != .外 {
                        KankenReadingRowView(row: row, type: type)
                    }
                }
                
                ForEach(SchoolLevel.allCases, id: \.self) { type in
                    if let row = getOnReading(type), type != .外 {
                        KankenReadingRowView(row: row, type: type)
                    }
                }
            }
            .opacity(hideKanjiReadings ? 0 : 1)
            
            Divider()
            
            Group {
                if let row = getKunReading(SchoolLevel.外) {
                    KankenReadingRowView(row: row, type: SchoolLevel.外)
                }
                if let row = getOnReading(SchoolLevel.外) {
                    KankenReadingRowView(row: row, type: SchoolLevel.外)
                }
            }
            .opacity(hideKanjiReadings ? 0 : 0.5)
            
            Divider()
            
            Divider()
        }
    }
    
    func getKunReading(_ type: SchoolLevel) -> String? {
        return currentKanji.kunReading[type]
    }
    
    func getOnReading(_ type: SchoolLevel) -> String? {
        return currentKanji.onReading[type]
    }
}

#Preview {
    KanjiReadings(currentKanji: .ANOTHER_MOCK_KANKENKANJI, hideKanjiReadings: .constant(false))
}
