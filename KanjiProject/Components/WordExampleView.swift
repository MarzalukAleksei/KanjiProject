//
//  WordExampleView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/27.
//

import SwiftUI

struct WordExampleView: View {
    var text: String = ""
    @EnvironmentObject var store: Store
//    let isLinked: Bool
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                JoinedTextView(text: text)
                
                Spacer()
                
                if !text.textAndLinks().isEmpty {
                    ButtonImages.chevronRight
                        .padding(Settings.paddingBetweenElements)
                        .opacity(Settings.opacity)
                }
            }
            Rectangle()
                .frame(height: 1)
                .opacity(Settings.opacity)
        }
        
    }
    
}

struct WordExampleView_Previews: PreviewProvider {
    static var previews: some View {
        WordExampleView(text: "TEXT")
            .environmentObject(Store())
            .padding(.horizontal, 20)
    }
}
