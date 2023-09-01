//
//  ProgressIndicatorView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/08.
//

import SwiftUI

struct ProgressIndicatorView: View {
    let answers: CGFloat
    let rightAnswers: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
//                Spacer()
                HStack(spacing: 0) {
                    Rectangle()
                        .frame(width: rightAnswers * (geometry.size.width / answers), height: 5)
                    Rectangle()
                        .frame(width: (answers - rightAnswers) * (geometry.size.width / answers), height: 5)
                        .opacity(0.3)
                }
//                Spacer()
            }
        }
    }
}

struct ProgressIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressIndicatorView(answers: 20, rightAnswers: 11)
            .padding(.top, 250)
            .padding()
    }
}
