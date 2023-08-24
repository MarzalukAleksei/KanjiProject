//
//  DismissButton.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/11.
//

import SwiftUI

struct DismissButton: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
//        VStack(spacing: 0) {
            Button {
                dismiss()
            } label: {
                ZStack {
//                    Text("Закрыть")
//                        .modifier(Modifiers.tabBarSize)
//                        .font(.largeTitle)
                    ButtonImages.dismissButtonImage
                        .resizable()
                        .frame(width: 30, height: 30)
                    HStack {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: PartsSize.dismissButtonShevronSize.width,
                                   height: PartsSize.dismissButtonShevronSize.height)
                            .padding(Settings.padding)
                        Spacer()
                    }
                }
                .background(Color.black.ignoresSafeArea())
//                .clipShape(PartialRoundedRectangle(cornerRadius: 20, corners: [.topLeft, .topRight]))
                .foregroundColor(.white)
            }
        .buttonStyle(.plain)
//            Rectangle().frame(height: 0)
//                .background(Color.black.ignoresSafeArea())
//        }
    }
}

struct DismissButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            DismissButton()
        }
    }
}
