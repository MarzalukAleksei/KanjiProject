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
            BoldDivider(depth: Settings.boldDividerDepth)
                .padding(.bottom, Settings.paddingBetweenText)
            
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
                .opacity(checkDividerVisibility() ? 1 : 0)
            
            Group {
                if let row = getKunReading(SchoolLevel.外) {
                    KankenReadingRowView(row: row, type: SchoolLevel.外)
                }
                if let row = getOnReading(SchoolLevel.外) {
                    KankenReadingRowView(row: row, type: SchoolLevel.外)
                }
            }
            .opacity(hideKanjiReadings ? 0 : 0.5)
            
            BoldDivider(depth: Settings.boldDividerDepth)
        }
    }
    
    private func checkDividerVisibility() -> Bool {
        if let _ = getKunReading(.外) {
            return true
        }
        if let _ = getOnReading(.外) {
            return true
        }
        return false
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
