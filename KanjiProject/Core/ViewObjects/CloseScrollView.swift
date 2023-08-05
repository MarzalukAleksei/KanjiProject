//
//  CloseScrollView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/04.
//

import SwiftUI

struct CloseScrollView: View {
    let imageName: String = "YellowScroll"
    @State var size: CGSize
    let title = "10-25"
    var body: some View {
        HStack(spacing: 0) {
            Image("WoodPart")
                .resizable()
                .modifier(CloseScrollMainWoodPartModifier(width: size.width))
            ZStack {
                Image("YellowScroll")
                    .resizable()
                    .modifier(CloseScrollBodyModifier(size: size))
                YellowLines(size: size)
                Image("Paper")
                    .resizable()
                    .cornerRadius(15)
                    .frame(width: size.height - 100, height: size.width - 20)
                RoundedRectangle(cornerRadius: 15)
                    .stroke(lineWidth: 1)
                    .frame(width: size.height - 120, height: size.width - 40)
                    .foregroundColor(.brown)
                Text(title)
                    .frame(width: size.height - 130, height: size.width - 50)
                    .font(FontStyle.scroll(size: 30))
            }
                
            Image("WoodPart")
                .resizable()
                .modifier(CloseScrollMainWoodPartModifier(width: size.width))
        }
    }
}

private struct YellowLines: View {
    let size: CGSize
    var body: some View {
        HStack {
            Rectangle()
                .frame(width: 4, height: size.width)
                .padding(.trailing, size.height - 40)
            Rectangle()
                .frame(width: 4, height: size.width)
        }
        .foregroundColor(.yellow)
    }
}

struct CloseSCrollView_Previews: PreviewProvider {
    static var previews: some View {
        CloseScrollView(size: CGSize(width: 70, height: 200))
    }
}
