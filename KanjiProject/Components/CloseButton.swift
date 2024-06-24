//
//  CloseButton.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/06/24.
//

import SwiftUI

struct CloseButton: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var globalChanging: GlobalChanging
    var body: some View {
        HStack {
            Button(action: {
                dismiss()
                globalChanging.exampleWord = nil
            }, label: {
                ButtonsImages.dismissButtonImage
                    .resizable()
                    .frame(width: ElementSize.xmarkSize.width,
                           height: ElementSize.xmarkSize.height)
                    .foregroundStyle(.black)
                    .opacity(0.4)
            })
            Spacer()
        }
    }
}

#Preview {
    CloseButton()
        .environmentObject(GlobalChanging())
}
