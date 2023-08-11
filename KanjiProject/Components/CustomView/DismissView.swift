//
//  DismissView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/11.
//

import SwiftUI

struct DismissView: View {
    
    var body: some View {
        ZStack {
            Text("Закрыть")
                .modifier(Modifiers.tabBarSize)
                .font(.largeTitle)
            HStack {
                Image(systemName: "chevron.left")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .padding(Settings.padding)
                Spacer()
            }
        }
        .background(Color.black.ignoresSafeArea())
        .foregroundColor(.white)
    }
}

struct DismissView_Previews: PreviewProvider {
    static var previews: some View {
        DismissView()
    }
}
