//
//  ListOfKanjiInGivenWordView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/06/30.
//

import SwiftUI

struct ListOfKanjiInGivenWordView: View {
    let kanji: [KanjiKankenModel]
    let size: CGFloat
    var body: some View {
        ForEach(kanji) { kanji in
            HStack {
                Text(kanji.body)
                    .font(.system(size: setKanjiSize()))
                VStack(alignment: .leading) {
                    if let meaning = kanji.meaningInRussion {
                        Text(meaning)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, Settings.paddingBetweenText / 2)
                    }
                    
                    ForEach(SchoolLevel.allCases, id: \.self) { level in
                        if let reading = kanji.kunReading[level], level != .外 {
                            HStack(alignment: .top) {
                                Text(level.rawValue)
                                Text(reading)
                            }
                        }
                    }
                    
                    ForEach(SchoolLevel.allCases, id: \.self) { level in
                        if let reading = kanji.onReading[level], level != .外 {
                            HStack(alignment: .top) {
                                Text(level.rawValue)
                                Text(reading)
                            }
                        }
                    }
                    
                    Group {
                        if let reading = kanji.kunReading[SchoolLevel.外] {
                            HStack(alignment: .top) {
                                Text(SchoolLevel.外.rawValue)
                                Text(reading)
                            }
                        }
                        
                        if let reading = kanji.onReading[SchoolLevel.外] {
                            HStack(alignment: .top) {
                                Text(SchoolLevel.外.rawValue)
                                Text(reading)
                            }
                        }
                    }
                    .opacity(0.5)
                }
                .font(.system(size: setReadingsSize()))
                
                Spacer()
                
                if let nouryokuLevel = kanji.nouryokuLevel, nouryokuLevel != .another {
                    Text("\(nouryokuLevel)")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
        }
    }
    
    func setReadingsSize() -> CGFloat {
//        return setKanjiSize() / 1.7
        return setKanjiSize() / 1.7 / 1.5
    }
    
    func setKanjiSize() -> CGFloat {
//        return size / 15
        return size / 15 / 1.5
    }
}


#Preview {
    ListOfKanjiInGivenWordView(kanji: [.ANOTHER_MOCK_KANKENKANJI, .MOCK_KANJIKANKEN, .ANOTHER_MOCK_KANKENKANJI], size: 300)
}
