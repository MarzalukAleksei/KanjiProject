//
//  SelectGroupView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/04.
//

import SwiftUI

struct SelectGroupView: View {
    let moc = Array(1...7)
    let padding = PartsSize.woodPartHeight * 2
    var body: some View {
        GeometryReader { geo in
            ScrollView() {
                VStack(spacing: 10) {
                    ForEach(moc, id: \.self) { row in
                        CloseScrollView(size: CGSize(width: scrollsHeight(inList: 7, geo), height: scrollsWidth(geo)))
                    }
                }
                .padding(.leading, padding / 2)
            }
            
        }
    }
    
    // Скролы повернуты на 90 градусов, поэтому ширина и высота поменялись местами
    func scrollsHeight(inList number: CGFloat, _ geo: GeometryProxy) -> CGFloat {
        return geo.size.height / (number + 1)
    }
    func scrollsWidth(_ geo: GeometryProxy) -> CGFloat {
        return geo.size.width - (padding * 2)
    }
}

struct SelectGroupView_Previews: PreviewProvider {
    static var previews: some View {
        SelectGroupView()
    }
}
