//
//  CheckmarkButton.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/06/25.
//

import SwiftUI

struct CheckmarkButton: View {
    @Environment(\.dismiss) var dismiss
    private var action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    var body: some View {
//        HStack {
//            Spacer()
            
            Button(action: {
                action()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    dismiss()
                }
            }, label: {
                ButtonsImages.checkmark
                    .resizable()
                    .frame(width: ElementSize.closeButton.width,
                           height: ElementSize.closeButton.height)
                //                .foregroundStyle(.black)
                    .opacity(0.4)
            })
//        }
    }
}

#Preview {
    CheckmarkButton(action: {})
}
