//
//  IdiomView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/29.
//

import SwiftUI

struct IdiomView: View {
    var body: some View {
        VStack {
            
            IdiomViewHeader(title: "四字熟語")
//                .frame(height: 230)
                .padding(.bottom, Settings.spacingBetweenIdiomHeaderAndElements)
            
                Text("TEXT")
                
                Spacer()
        }
    }
}

struct IdiomView_Previews: PreviewProvider {
    static var previews: some View {
        IdiomView()
    }
}
