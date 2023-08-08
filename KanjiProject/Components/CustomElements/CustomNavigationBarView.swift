//
//  CustomNavigationBarView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/08.
//

import SwiftUI

struct CustomNavigationBarView: View {
    var title = ""
    var body: some View {
        VStack(spacing: 0) {
            Color.black.ignoresSafeArea().frame(width: .infinity, height: 0)
            HStack {
                Spacer()
                Text(title)
                    .font(.title)
                    .frame(width: .infinity, height: 120, alignment: .bottom)
                    .padding(.bottom, 15)
                    .foregroundColor(.white)
                Spacer()
            }
            .background(Color.black.ignoresSafeArea())
            .clipShape(PartialRoundedRectangle(cornerRadius: PartsSize.navigationCornerRadius, corners: .bottomLeft))
        }
    }
}

struct CustomNavigationBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CustomNavigationBarView(title: "Preview")
            Spacer()
        }
        
    }
}
