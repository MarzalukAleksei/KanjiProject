//
//  CustomToggleView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/09.
//

import SwiftUI

struct CustomToggleView: View {
    @State var toggle: Bool
    var title: (left: String, right: String) = ("", "")
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Rectangle()
                    .opacity(Settings.opacity)
                    .clipShape(RoundedRectangle(cornerRadius: geo.size.height * Settings.customToggleViewCornerRadius))
                HStack(spacing: 0) {
                    OpacityRectangle(
                        size: CGSize(width: toggle ? geo.size.width - geo.size.height : 0,
                                     height: geo.size.height),
                        corners: [.topLeft, .bottomLeft]
                    )
                    
                    BlackRectangle(
                        geo: geo,
                        corners: .allCorners,
                        title: toggle ? title.right : title.left
                    )
                    
                    OpacityRectangle(
                        size: CGSize(width: toggle ? 0 : geo.size.width - geo.size.height,
                                     height: geo.size.height),
                        corners: [.topRight, .bottomRight]
                    )
                    
                }
            }
            .onTapGesture {
                withAnimation {
                    toggle.toggle()
                }
            }
        }
    }
}

private struct BlackRectangle: View {
    let geo: GeometryProxy
    let corners: UIRectCorner
    let title: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: geo.size.height)
                .background(Color.blue)
                .clipShape(PartialRoundedRectangle(cornerRadius: geo.size.height * Settings.customToggleViewCornerRadius, corners: corners))
            
            Text(title)
                .foregroundColor(.white)
        }
    }
}

private struct OpacityRectangle: View {
    let size: CGSize
    let corners: UIRectCorner
    var body: some View {
        Rectangle()
            .frame(width: size.width)
            .opacity(0)
            .clipShape(PartialRoundedRectangle(cornerRadius: size.height * Settings.customToggleViewCornerRadius, corners: corners))
    }
}

struct CustomToggleView_Previews: PreviewProvider {
    static var previews: some View {
        CustomToggleView(toggle: false, title: ("問", "漢"))
            .frame(width: 200, height: 75)
    }
}
