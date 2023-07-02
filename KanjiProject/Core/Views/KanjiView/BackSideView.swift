//
//  BackSideView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/06/22.
//

import SwiftUI

struct BackSideView: View {
    
    let kanji: KanjiModel
    
//    private let grid: [GridItem] = [
//        .init(.flexible(), spacing: 2, alignment: .leading),
//        .init(.flexible(), spacing: 2, alignment: .leading),
////        .init(.flexible(), spacing: 2, alignment: .leading)
//    ]
    
    var body: some View {
        ZStack {
            Rectangle()
                .modifier(CardViewModifire())
            
            VStack(spacing: 20) {
                Text(kanji.body)
                    .font(FontStyle.cardMainKanji)
                
                VStack(spacing: 20) {
                    HStack {
//                        ForEach(readingDevider(value: kanji.kun), id: \.self) { kun in
//                            Text(kun)
//                                .lineLimit(0)
//                        }
                        Text(toNewLine(value: kanji.kun))
                        
                        Spacer()
                    }
                    
//                    LazyVGrid(columns: grid) {
//                        ForEach(readingDevider(value: kanji.kun), id: \.self) { kun in
//                            Text(kun)
//                                .lineLimit(0)
//
//                        }
////                        Spacer()
//                    }
                    
                    HStack {
                        ForEach(readingDevider(value: kanji.on), id: \.self) { on in
                            Text(on)
                        }
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text(kanji.translate)
                            .lineLimit(0)
                            .font(.system(size: 25))
                        
                        Spacer()
                    }
                }
                .font(.system(size: 20))
                
                Spacer()
                
            }
            .padding(10)
        }
    }
    func readingDevider(value: String) -> [String] {
        var result: [String] = []
        result = value.components(separatedBy: "・")
        
        return result
    }
    
    func toNewLine(value: String) -> String {
        var result = value.replacingOccurrences(of: "・", with: "\n")
        
        return result
    }
}

struct BackSideView_Previews: PreviewProvider {
    static var previews: some View {
        BackSideView(kanji: .MOCK_KANJI)
    }
}