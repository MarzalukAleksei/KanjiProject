//
//  LearnWordView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/11/04.
//

import SwiftUI

struct LearnWordView: View {
    var body: some View {
        VStack {
            HStack {
                CloseButton()
                
                Spacer()
            }
            
            Spacer()
        }
        .padding(Settings.padding)
        .navigationBarHidden(true)
    }
}

#Preview {
    LearnWordView()
}
