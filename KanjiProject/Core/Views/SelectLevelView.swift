//
//  SelectLevelView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/15.
//

import SwiftUI

struct SelectLevelView: View {
    let level: [Level] = [.N1, .N2, .N3, .N4, .N5]
    @Binding var stores: Stores
    @Binding var path: NavigationPath
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                BackgroundView(array: stores.kanjistore.getData())
                VStack {
                    ForEach(level, id: \.self) { lv in
                        ScrollButton(title: "JLPT \(lv)", subtitle: "", size: buttonSize(geometry: geometry))
                            .onTapGesture {
                                print(lv.rawValue)
                                path.append(lv)
                            }
                    }
                    .navigationDestination(for: Level.self) { lvl in
                        KanjiListView(array: transform(lvl: lvl.rawValue), path: $path)
                    }
                    Spacer()
                }
                .padding(10)
            }
        }
    }
    
    func transform(lvl: Int) -> [[KanjiModel]] {
        var result: [[KanjiModel]] = []
        let lvlArray = stores.kanjistore.getData().filter { $0.level == lvl }
        var row: [KanjiModel] = []
        
        for element in lvlArray {
            if row.count < 10 {
                row.append(element)
            } else {
                result.append(row)
                row.removeAll()
            }
        }
        if !row.isEmpty {
            result.append(row)
        }
        return result
    }
        
    func buttonSize(geometry: GeometryProxy) -> CGSize {
        let width = geometry.size.width
        let height = geometry.size.height / CGFloat(level.count + 2)
        return CGSize(width: width, height: height)
    }
        
}

struct SelectLevelView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SelectLevelView(stores: .constant(.init()), path: .constant(.init()))
        }
    }
}
