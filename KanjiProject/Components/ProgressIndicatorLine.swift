//
//  ProgressIndicatorView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/08.
//

import SwiftUI

struct ProgressIndicatorLine: View {
    let answers: CGFloat
    let rightAnswers: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
//            VStack {
//                Spacer()
                HStack(spacing: 0) {
                    Rectangle()
                        .frame(width: rightAnswers * (geometry.size.width / answers), height: 5)
                    Rectangle()
                        .frame(width: (answers - rightAnswers) * (geometry.size.width / answers), height: 5)
                        .opacity(0.3)
                }
//            }
        }
    }
}

struct ProgressIndicatorLine_Previews: PreviewProvider {
    static var previews: some View {
        ProgressIndicatorLine(answers: 7, rightAnswers: 7)
            .padding(.top, 250)
            .padding()
    }
}
