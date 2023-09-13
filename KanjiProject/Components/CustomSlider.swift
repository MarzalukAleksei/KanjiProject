//
//  CustomSlider.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/09.
//

import SwiftUI

struct CustomSlider: View {
    @Namespace var namespace
    @Binding var toggle: Bool
    var title: (left: String, right: String) = ("", "")
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Rectangle()
                    .opacity(Settings.opacity)
                    .clipShape(RoundedRectangle(cornerRadius: geo.size.height * Settings.customToggleViewCornerRadius))
                if !toggle {
                    HStack {
                        BlackRectangle(geo: geo, corners: .allCorners, title: title.left)
                            .matchedGeometryEffect(id: "slider", in: namespace)
                        Spacer()
                    }
                } else {
                    HStack {
                        Spacer()
                        BlackRectangle(geo: geo, corners: .allCorners, title: title.right)
                            .matchedGeometryEffect(id: "slider", in: namespace)
                    }
                }
            }
            .onTapGesture {
                withAnimation(Settings.animation) {
                    toggle.toggle()
                }
            }
        }
    }
}

fileprivate struct BlackRectangle: View {
    let geo: GeometryProxy
    let corners: UIRectCorner
    let title: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: geo.size.height)
                .clipShape(PartialRoundedRectangle(cornerRadius: geo.size.height * Settings.customToggleViewCornerRadius, corners: corners))
            
            Text(title)
                .foregroundColor(.white)
                .font(CustomFont.scroll(size: geo.size.height * 0.7))
        }
    }
}

struct CustomSlider_Previews: PreviewProvider {
    static var previews: some View {
        CustomSlider(toggle: .constant(false), title: ("問", "漢"))
            .frame(width: 200, height: 75)
        CustomSlider(toggle: .constant(true), title: ("問", "漢"))
            .frame(width: 200, height: 75)
    }
}
