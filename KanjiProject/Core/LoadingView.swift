//
//  LoadingView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/02/26.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Image("Paper")
                .resizable()
                .ignoresSafeArea()
            VStack {
                Text("Идет загрузка")
                    .font(.system(size: 50))
                    .foregroundStyle(.black)
                ProgressView()
                    .foregroundStyle(.black)
            }
        }
    }
}

#Preview {
    LoadingView()
}
