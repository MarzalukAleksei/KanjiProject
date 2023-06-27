//
//  FrontSideVIew.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/06/22.
//

import SwiftUI

struct FrontSideVIew: View {
    let kanji: KanjiModel
    @State var id: Int = 11
    
    var body: some View {
        ZStack {
            Rectangle()
                .modifier(CardViewModifire())
            VStack {
                HStack {
                    Spacer()
                    Text("\(kanji.number)")
                }
                Spacer()
            }
            .padding(20)
            
            VStack {
                Text(kanji.body)
                    .font(FontStyle.cardMainKanji)
                
                    VStack(alignment: .leading) {
                        HStack {
                            VStack(alignment: .leading, spacing: 15) {
                                ForEach(okurigana(), id: \.self) { obj in
//                                    if obj != "" {
                                        Text(kanji.body + obj)
//                                    } else {
//                                        Text(kanji.body)
//                                    }
                                    
                                }
                                .font(.system(size: 25))
                            }
                            Spacer()
                        }
                    }
                
                HStack {
                    
                }
                
                Spacer()
            }
            .padding(10)
        }
    }
    func okurigana() -> [String] {
        let okurigana = kanji.kun.components(separatedBy: "・")
        var result = [String]()
        for string in okurigana {
            if string.contains("-") {
                let okurigana = string.components(separatedBy: "-")
                result.append(okurigana[1])
            }
        }
        
//        if okurigana.count != result.count {
//            result.append("")
//        }
        
        return result.sorted()
    }
}

struct FrontSideVIew_Previews: PreviewProvider {
    static var previews: some View {
        FrontSideVIew(kanji: .MOCK_KANJI)
    }
}
