//
//  ListOfKanjiInGivenWordView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/06/30.
//

import SwiftUI

struct ListOfKanjiInGivenWordView: View {
    let kanji: [KanjiKankenModel]
    let action: (_ currentKanji: KanjiKankenModel) -> Void
    
    init(kanji: [KanjiKankenModel], action: @escaping (_ currentKanji: KanjiKankenModel) -> Void = { _ in }) {
        self.kanji = kanji
        self.action = action
    }
    
    var body: some View {
        ForEach(kanji) { kanji in
            Row(kanji: kanji, action: action)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
        }
    }
}

#Preview {
    ListOfKanjiInGivenWordView(kanji: [.ANOTHER_MOCK_KANKENKANJI, .MOCK_KANJIKANKEN, .ANOTHER_MOCK_KANKENKANJI])
}

private struct Row: View {
    @EnvironmentObject var userSettings: UserSettings
    let kanji: KanjiKankenModel
    let action: (_ currentKanji: KanjiKankenModel) -> Void
    var body: some View {
        HStack {
            Text(kanji.body)
                .font(.system(size: Settings.listKanjiSettings.kanji))
                .padding(.top, Settings.listKanjiSettings.readings)
            HStack {
                VStack(alignment: .leading) {
                    if let meaning = kanji.meaningInRussion {
                        Text(meaning)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, Settings.paddingBetweenText / 2)
                            .font(.system(size: Settings.listKanjiSettings.readings))
                    }
                    
                    ForEach(SchoolLevel.allCases, id: \.self) { level in
                        if let reading = kanji.kunReading[level], level != .外 {
                            ReadingRow(schoolLevel: level.rawValue, reading: reading)
                        }
                    }
                    
                    ForEach(SchoolLevel.allCases, id: \.self) { level in
                        if let reading = kanji.onReading[level], level != .外 {
                            ReadingRow(schoolLevel: level.rawValue, reading: reading)
                        }
                    }
                    
                    Group {
                        if let reading = kanji.kunReading[SchoolLevel.外] {
                            ReadingRow(schoolLevel: SchoolLevel.外.rawValue, reading: reading)
                        }
                        
                        if let reading = kanji.onReading[SchoolLevel.外] {
                            ReadingRow(schoolLevel: SchoolLevel.外.rawValue, reading: reading)
                        }
                    }
                    .opacity(Settings.listKanjiSettings.opacity)
                    
//                    if userSettings.showSenceInJapanese {
//                        Text(kanji.meaning)
//                    }
                }
                .font(.system(size: Settings.listKanjiSettings.readings))
                
                Spacer()
                
                VStack {
                    if let nouryokuLevel = kanji.nouryokuLevel, nouryokuLevel != .another {
                        Text("\(nouryokuLevel)")
                    }
                    
                    Spacer()
                    
                    Button {
                        action(kanji)
                    } label: {
                        Color.clear
                            .frame(maxWidth: Settings.listKanjiSettings.readings)
                            .contentShape(Rectangle())
                            .overlay {
                                ButtonsImages.arrowForward
                                    .foregroundStyle(Color.black)
                                    .opacity(Settings.listKanjiSettings.opacity)
                            }
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

struct ReadingRow: View {
    let schoolLevel: String
    let reading: String
    var body: some View {
        HStack(alignment: .top) {
            Text(schoolLevel)
            Text(reading)
        }
    }
}
