//
//  OpenScrollView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/15.
//

import SwiftUI

struct OpenScrollView: View {
    let imageName = "YellowScroll"
    let size: CGSize
    let title: String = "10-25"
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    Image("WoodPart")
                        .resizable()
                        .modifier(ScrollMainWoodPartModifier(width: size.width,
                                                             corners: [.topLeft, .topRight]))
                        
                    ZStack {
                        Image(imageName)
                            .resizable()
                            .modifier(ScrollBodyBodifier(size: size))
                        YellowLines(size: size)
                        Image("Paper")
                            .resizable()
                            .frame(width: size.width - 15,
                                   height: size.height - 60)
                            .cornerRadius(5)
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lineWidth: 1)
                            .foregroundColor(.brown)
                            .frame(width: size.width - 25,
                                   height: size.height - 70)
                        VStack {
                            ForEach(transformTitle(), id: \.self) { character in
                                if transformTitle().count <= 5 {
                                    Text(character)
                                        .font(CustomFont.scroll(size: 20))
                                } else {
                                    Text(character)
                                        .font(CustomFont.scroll(size: 15))
                                }
                            }
                        }
                    }
                    .modifier(OpenScrollParticalRoundedModifier(cornerRadius: size.width / 8,
                                                                corners: [.topLeft, .bottomLeft]))
                    Image("WoodPart")
                        .resizable()
                        .modifier(ScrollMainWoodPartModifier(width: size.width,
                                                             corners: [.bottomLeft, .bottomRight]))
                }
                VStack(alignment: .leading, spacing: 0) {
                    ZStack(alignment: .leading) {
                        Image(imageName)
                            .resizable()
                            .frame(width: .infinity, height: size.height)
                            .rotationEffect(.degrees(180))
                        Image("Paper")
                            .resizable()
                            .frame(width: .infinity, height: size.height - 30)
                    }
                }
                VStack(spacing: 0) {
                    Image("WoodPart")
                        .resizable()
                        .modifier(ScrollLittleWoodPartModifier(corners: [.topLeft, .topRight]))
                    ZStack {
                        Image(imageName)
                            .resizable(capInsets: .init(top: 0, leading: 0, bottom: 0, trailing: 4))
                            .frame(width: 16, height: size.height)
                        YellowLines(size: CGSize(width: 16, height: size.height))
                    }
                    .modifier(OpenScrollParticalRoundedModifier(cornerRadius: size.width / 9, corners: [.topRight, .bottomRight]))
                    
                    Image("WoodPart")
                        .resizable()
                        .modifier(ScrollLittleWoodPartModifier(corners: [.bottomLeft,
                                                                         .bottomRight]))
                }
            }
        }
        .padding(.horizontal, 10)
    }
    
    func transformTitle() -> [String] {
        return title.map { String($0) }
    }
}

private struct YellowLines: View {
    let size: CGSize
    var body: some View {
        VStack {
            Rectangle()
                .frame(width: size.width, height: 4)
                .padding(.bottom, size.height - 21)
            Rectangle()
                .frame(width: size.width, height: 4)
        }
        .foregroundColor(.yellow)
    }
}

struct ScrollButton_Previews: PreviewProvider {
    static var previews: some View {
        OpenScrollView(size: CGSize(width: 50, height: 180))
    }
}
