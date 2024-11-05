//
//  CloseButton.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/06/24.
//

import SwiftUI

struct CloseButton: View {
    @Environment(\.dismiss) var dismiss
//    @EnvironmentObject private var globalChanging: GlobalChanging
    private var action: () -> Void
    
    init(action: @escaping () -> Void = {}) {
        self.action = action
    }
    
    var body: some View {
//        HStack {
            Button(action: {
                dismiss()
//                globalChanging.exampleWord = nil
                action()
            }, label: {
                ButtonsImages.dismissButtonImage
                    .resizable()
                    .frame(width: ElementSize.closeButton.width,
                           height: ElementSize.closeButton.height)
                    .foregroundStyle(.black)
                    .opacity(0.4)
            })
//            Spacer()
//        }
    }
}

#Preview {
    CloseButton()
        .environmentObject(GlobalChanging())
}
