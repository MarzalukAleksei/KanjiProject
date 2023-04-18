//
//  KanjiListView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/15.
//

import SwiftUI

struct KanjiListView: View {
    @State var array: [[KanjiModel]]
    @Binding var path: NavigationPath
    
    var body: some View {
//        ScrollsView {
            Text("")
//        }
    }
    
    func fontSize(_ geometry: GeometryProxy) {
        let width = geometry.size.width - 10 / 10
        let height = width
        
    }
    
//    func width(_ geometry: GeometryProxy) -> CGFloat {
//
//    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        KanjiListView(array: [], path: .constant(.init()))
    }
}
