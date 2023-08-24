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
    let cornerRadius: CGFloat
    var heigh: CGFloat
    var body: some View {
        VStack(spacing: 0) {
            Color.black.ignoresSafeArea().frame(maxWidth: .infinity, maxHeight: 0)
            HStack {
                Spacer()
                Text(title)
                    .font(CustomFont.scroll(size: 25))
                    .frame(maxWidth: .infinity, maxHeight: heigh, alignment: .bottom)
                    .padding(.bottom, Settings.customNavigationBarTitlePadding)
                    .foregroundColor(.white)
                Spacer()
            }
            .background(Color.black)
            .clipShape(PartialRoundedRectangle(cornerRadius: cornerRadius, corners: corners))
        }
    }
}

struct CustomNavigationBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CustomNavigationBarView(title: "Preview", corners: .bottomLeft, cornerRadius: PartsSize.navigationCornerRadius, heigh: PartsSize.customNavigationBarHeight)
            Spacer()
        }
        
    }
}
