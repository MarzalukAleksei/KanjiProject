//
//  BackgroundView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/02.
//

import SwiftUI

struct BackgroundView: View {
    
    enum Level {
        case N1, N2, N3, N4, N5, All
    }
    
    let level: Level
    private let size: CGFloat = 30
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                VStack {
                    ForEach(backBroundsElements(geometry: geometry),
                            id: \.self) { row in
                        HStack {
                            ForEach(row, id: \.self) { element in
                                Text(element.body)
                                    .frame(width: size, height: size)
                                    .font(.system(size: size))
                                    .foregroundColor(.black.opacity(0.2))
                                    .padding(0)
                                    
                            }
                        }
                        .padding(5)
                    }
                }
            }
            .padding(5)
        }
    }
    
    func elementsOnRow(geometry: GeometryProxy) -> CGFloat{
        let inLine = geometry.size.width / size
        return inLine
    }
    
    func elemtntsOnSection(geometry: GeometryProxy) -> CGFloat {
        let inSection = geometry.size.height / size
        return inSection
    }
    
    func backBroundsElements(geometry: GeometryProxy) -> [[KanjiModel]]{
        var result: [[KanjiModel]] = []
        for _ in 1...Int(elemtntsOnSection(geometry: geometry)) {
            var row: [KanjiModel] = []
            for _ in 1...Int(elementsOnRow(geometry: geometry)) {
                row.append(KanjiModel(body: "漢", kun: "", on: "", translate: ""))
            }
            result.append(row)
        }
        
        return result
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView(level: .All)
    }
}
