//
//  CustomNavigationBarView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/08.
//

import SwiftUI

struct CustomNavigationBarView: View {
    var title = ""
    let corners: UIRectCorner
    let heigh: CGFloat
    var body: some View {
        VStack(spacing: 0) {
            Color.black.ignoresSafeArea().frame(maxWidth: .infinity, maxHeight: 0)
            HStack {
                Spacer()
                Text(title)
                    .font(.title)
                    .frame(maxWidth: .infinity, maxHeight: PartsSize.customNavigationBarHeight, alignment: .bottom)
                    .padding(.bottom, PartsSize.customNavigationBarTitlePadding)
                    .foregroundColor(.white)
                Spacer()
            }
            .background(Color.black)
            .clipShape(PartialRoundedRectangle(cornerRadius: PartsSize.navigationCornerRadius, corners: corners))
        }
    }
}

struct CustomNavigationBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CustomNavigationBarView(title: "Preview", corners: .bottomLeft, heigh: PartsSize.customNavigationBarHeight)
            Spacer()
        }
        
    }
}
