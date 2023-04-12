//
//  NavigationView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/11.
//

import SwiftUI

struct BackgroundView: View {
    let array: [KanjiModel]
    @State var navigationPath = NavigationPath()
    @State private var twoDemensionalArray = [[KanjiModel]]()
    var body: some View {
//        NavigationStack(path: $navigationPath) {
                GeometryReader(content: { geometry in
                    VStack(spacing: 0) {
                        ForEach(twoDemensionalArray, id: \.self) { row in
                            HStack(spacing: 0) {
                                ForEach(row, id: \.self) { element in
                                    Text(element.body)
                                        .frame(width: amountWidth(geometry: geometry, amountCount: row), height: amountHeight(geometry: geometry, amountCount: twoDemensionalArray))
                                        .foregroundColor(.black.opacity(0.2))
//                                        .background(Color.gray)
                                        .font(.system(size: totalSize(geometry: geometry, array: twoDemensionalArray) - 2))
                                }
                            }
                        }
                    }
                    .padding(5)
                    .onAppear() {
                        twoDemensionalArray = array(geometry: geometry)
                    }
                })
//                .navigationTitle("Main")
//            .navigationBarTitleDisplayMode(.inline)
//            .frame(width: size.width, height: size.height)
            
//        }
        
    }
    
    func getElement() -> String {
        
        return ""
    }
    
    func totalSize(geometry: GeometryProxy, array: [[KanjiModel]]) -> CGFloat {
        let width = amountWidth(geometry: geometry, amountCount: array.first ?? [])
        let heignt = amountHeight(geometry: geometry, amountCount: array)
        let ratio = heignt / width
        let result = 30 * ratio
        return result
    }
    
    func amountWidth(geometry: GeometryProxy, amountCount: [KanjiModel]) -> CGFloat {
        let width = geometry.size.width - 10
        let result = width / CGFloat(amountCount.count)
        return result
    }
    
    func amountHeight(geometry: GeometryProxy, amountCount:[[KanjiModel]]) -> CGFloat {
        let height = geometry.size.height - 10
        let result = height / CGFloat(amountCount.count)
        return result
    }
    
    func array(geometry: GeometryProxy) -> [[KanjiModel]] {
        var result: [[KanjiModel]] = []
        let section = inSection(geometry: geometry)
        let inRow = inRow(geometry: geometry)
        for _ in 0..<section {
            var row: [KanjiModel] = []
            for _ in 0..<inRow {
                row.append(array.randomElement() ?? KanjiModel(body: "漢", kun: "", on: "", translate: "", number: 0, level: 0))
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
    }
}
