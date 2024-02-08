//
//  DrawModalView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/11/03.
//

import SwiftUI

struct DrawModalView: View {
    @State private var path = Path()
    
    var body: some View {
        VStack(spacing: Settings.paddingBetweenElements) {
            HStack {
                Spacer()
                Button("TEST") {
                    CoreMLManager().getPrediction(path: path)
                }
                Button {
                    path = Path()
                } label: {
                    ButtonsImages.delete
                        .resizable()
                        .frame(width: ElementSize.pencilButtonSize.width, height: ElementSize.pencilButtonSize.height)
                }
                .foregroundStyle(.black)
            }
            .padding(.horizontal, Settings.padding)
            
            GeometryReader { geo in
                HStack {
                    Spacer()
//                    DrawView(path: $path, size: setDrawViewSize(geo))
                    DrawView(path: $path, size: CGSize(width: 299, height: 299))
                    Spacer()
                }
            }
        }
    }
    func setDrawViewSize(_ geo: GeometryProxy) -> CGSize {
        var size = geo.size
        size.width = size.width - (Settings.padding * 2)
        size.height = size.width
        
        return size
    }
}

#Preview {
    DrawModalView()
}
