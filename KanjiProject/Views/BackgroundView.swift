//
//  BackgroundView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/02.
//

import SwiftUI

struct BackgroundView: View {
    
    private let size: CGFloat = 30
    private let padding: CGFloat = 5
    let array: [KanjiModel]
    @State var elements: [[KanjiModel]] = []
    @State var width: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                VStack {
                    ForEach(backBroundsElements(geometry: geometry), id: \.self) { row in
                        HStack(alignment: .center, spacing: 0) {
                            ForEach(row, id: \.self) { element in
                                Text(element.body)
//                                    .frame(width: width(geometry: geometry), height: size)
                                    .frame(width: size, height: size)
//                                    .font(.system(size: width(geometry: geometry)))
                                    .font(.system(size: size))
                                    .foregroundColor(.black.opacity(0.2))
                                    .padding(.horizontal, 4)
                                    
                                    
                            }
                        }
                        .padding(.horizontal, padding)
                    }
                }
            }
//            .padding(0)
        }
        
    }
    
    private func width(geometry: GeometryProxy) -> CGFloat {
        let width = geometry.size.width
        let inLine = width / (size + padding) + 1
        let remains = inLine - inLine.rounded(.towardZero)
        let result = size + size * remains
        return result
    }
    
    private func elementsInRow(geometry: GeometryProxy) -> Int {
//        let inLine = geometry.size.width / size - 3
        let width = geometry.size.width - (size + padding) - padding * 2
        let inRow = width / (size + padding) + 1
        print(inRow)
        return Int(inRow)
    }
    
    private func elemtntsInSection(geometry: GeometryProxy) -> Int {
        let height = geometry.size.height - (size + padding) - padding * 2
        let inSection = height / (size + padding) + 1
        return Int(inSection)
    }
    
    private func backBroundsElements(geometry: GeometryProxy) -> [[KanjiModel]] {
        var result: [[KanjiModel]] = []
        for _ in 1...elemtntsInSection(geometry: geometry) {
            var row: [KanjiModel] = []
            for _ in 1...elementsInRow(geometry: geometry) {
                if let obj = array.randomElement() {
                    row.append(obj)
                }
            }
            result.append(row)
        }
        
        return result
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView(array: [KanjiModel(body: "漢", kun: "", on: "", translate: "",number: 0, level: 0)])
    }
}
