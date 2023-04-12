//
//  SwiftUIView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/11.
//

import SwiftUI

struct MainViewButton: View {
    let size: CGSize
    let title: String
    
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.green)
            HStack {
                Spacer()
                VStack {
                    ForEach(data(), id: \.self) { element in
                        Text(element)
                            .font(Font.system(size: size.width / 3))
                    }
                    Spacer()
                }
                .padding()
            }
        }
        .frame(width: size.width, height: size.height)
    }
    func data() -> [String] {
        let result: [String] = title.map { character in
            return String(character)
        }
        return result
    }
}

struct MainViewButton_Previews: PreviewProvider {
    static var previews: some View {
        MainViewButton(size: CGSize(width: 100, height: 200), title: "漢字")
    }
}

