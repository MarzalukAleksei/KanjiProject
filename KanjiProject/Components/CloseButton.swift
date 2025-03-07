//
//  CloseButton.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/06/24.
//

import SwiftUI

struct CloseButton: View {
    @Environment(\.dismiss) private var dismiss
    private var action: () -> Void
    
    init(action: @escaping () -> Void = {}) {
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            dismiss()
            action()
        }, label: {
            ButtonsImages.dismissButtonImage
                .resizable()
                .modifier(Modifiers.closeButton)
        })
    }
}

#Preview {
    CloseButton()
        .environmentObject(GlobalChanging())
}
