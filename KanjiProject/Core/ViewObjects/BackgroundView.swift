//
//  NavigationView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/11.
//

import SwiftUI

struct BackgroundView: View {
    let array: [Any]
//    @State var navigationPath = NavigationPath()
    @State private var twoDemensionalArray: [[String]] = []
    var body: some View {
                GeometryReader(content: { geometry in
                    VStack(spacing: 0) {
                        ForEach(twoDemensionalArray, id: \.self) { row in
                            HStack(spacing: 0) {
                                ForEach(row, id: \.self) { element in
                                    Text(element)
                                        .frame(width: amountWidth(geometry: geometry, amountCount: row), height: amountHeight(geometry: geometry, amountCount: twoDemensionalArray))
                                        .foregroundColor(.black.opacity(0.2))
//                                        .font(.system(size: totalSize(geometry: geometry, array: twoDemensionalArray) - 2))
                                        .font(FontStyle.background(size: totalSize(geometry: geometry, array: twoDemensionalArray) - 2))
//                                        .font(.custom("ZeroGothic", size: 30))
                                }
                            }
                        }
                    }
                    .padding(5)
                    .onAppear {
                        twoDemensionalArray = array(geometry: geometry)
                    }
                })
        
    }
    
    func getElement() -> String {
        let element = array.randomElement()
        
        switch element {
        case is KanjiModel:
            guard let element = element as? KanjiModel else { return "" }
            return element.body
        case is HiraganaModel:
            guard var element = element as? HiraganaModel else { return "" }
            while element.kana.count > 1 {
                guard let value = array.randomElement() as? HiraganaModel else { return "H" }
                element = value
                
            }
            return element.kana
        case is KatakanaModel:
            guard var element = element as? KatakanaModel else { return "" }
            while element.kana.count > 1 {
                guard let value = array.randomElement() as? KatakanaModel else { return "K" }
                element = value
                
            }
            return element.kana
        case _:
            return "X"
        }
    }
    
    func totalSize(geometry: GeometryProxy, array: [[String]]) -> CGFloat {
        let width = amountWidth(geometry: geometry, amountCount: array.first ?? [])
        let heignt = amountHeight(geometry: geometry, amountCount: array)
        let ratio = heignt / width
        let result = 30 * ratio
        return result
    }
    
    func amountWidth(geometry: GeometryProxy, amountCount: [String]) -> CGFloat {
        let width = geometry.size.width - 10
        let result = width / CGFloat(amountCount.count)
        return result
    }
    
    func amountHeight(geometry: GeometryProxy, amountCount:[[String]]) -> CGFloat {
        let height = geometry.size.height - 10
        let result = height / CGFloat(amountCount.count)
        return result
    }
    
    func array(geometry: GeometryProxy) -> [[String]] {
        var result: [[String]] = []
        let section = inSection(geometry: geometry)
        let inRow = inRow(geometry: geometry)
        for _ in 0..<section {
            var row: [String] = []
            for _ in 0..<inRow {
                row.append(getElement())
            }
            result.append(row)
        }
        return result
    }
    
    func inRow(geometry: GeometryProxy) -> Int {
        let width = geometry.size.width - 10
        let result = width / 30
        return Int(result.rounded(.towardZero))
    }
    
    func inSection(geometry: GeometryProxy) -> Int {
        let height = geometry.size.height - 10
        let result = height / 30
        return Int(result)
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView(array: [KanjiModel(body: "漢", kun: "", on: "", translate: "", number: 0, level: 0)])
//        BackgroundView(array: [HiraganaModel(kana: "あ"), HiraganaModel(kana: "しゃ")])
    }
}
