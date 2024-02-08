//
//  ProgressIndicatorView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/08.
//

import SwiftUI

struct ProgressIndicatorBar: View {
    let answers: CGFloat
    let rightAnswers: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: .infinity)
                    .opacity(0.3)
                RoundedRectangle(cornerRadius: .infinity)
                    .frame(width: geometry.size.width * rightAnswers / answers)
            }
        }
        .frame(height: Settings.progressBarHeight)
    }
}

struct ProgressIndicatorBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressIndicatorBar(answers: 10, rightAnswers: 7)
            .padding(.top, 250)
            .padding()
    }
}
