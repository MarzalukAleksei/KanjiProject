//
//  KankenExamplesRowView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/11/05.
//

import SwiftUI

struct KankenExamplesRowView: View {
    @EnvironmentObject var store: Store
    let currentKankenKanji: KanjiKankenModel
    
    var body: some View {
        ForEach(SchoolLevel.allCases, id: \.self) { level in
            if let array = currentKankenKanji.examplesWithReading[level] {
                ForEach(Array(array.enumerated()), id: \.element) { (index, row) in
                    HStack(spacing: 0) {
                        ForEach(row, id: \.self) { part in
                            VStack {
                                MarkKanjiInRow(part: part, currentKanji: currentKankenKanji, readingIsHidden: false)
                                Spacer()
                            }
                        }
                        VStack {
                            Text("")
                            Text(" - ")
                                .font(.system(size: TextSizes.dash))
                            Spacer()
                        }
//                        .frame(maxWidth: .infinity)
                        
                        VStack {
                            Text("SOME DATA")
                        }
                        
                        Spacer()
                    }
                    Rectangle()
                        .frame(height: 1)
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
}

fileprivate struct MarkKanjiInRow: View {
    let part: TextAndReading
    let currentKanji: KanjiKankenModel
    let readingIsHidden: Bool
    var body: some View {
        VStack {
            if currentKanji.body == part.text {
                Text(part.reading)
                    .font(.system(size: 12))
                    .foregroundStyle(.red)
                    .opacity(readingIsHidden ? 0 : 1)
                Text(part.text)
                    .font(.system(size: TextSizes.kanjiBody))
                    .foregroundStyle(.red)
            } else {
                Text(part.reading)
                    .font(.system(size: 12))
                    .opacity(readingIsHidden ? 0 : 1)
                Text(part.text.removeBrackets())
                    .font(.system(size: TextSizes.kanjiBody))
            }
        }
    }
}

#Preview {
    KankenExamplesRowView(currentKankenKanji: .MOCK_KANJIKENTEI)
        .environmentObject(Store())
}
