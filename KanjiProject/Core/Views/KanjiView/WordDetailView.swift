//
//  WordDetailView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/21.
//

import SwiftUI

struct WordDetailView: View {
    
    let word: DictionaryModel
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBarView(title: word.body,
                                    corners: .bottomRight,
                                    cornerRadius: PartsSize.navigationCornerRadius,
                                    heigh: PartsSize.wordDetailViewNavigationBarHight)
            ZStack {
                Rectangle()
                    .modifier(Modifiers.roundedRectTopLeftBlackPart)
                
                VStack {
                    Text(word.reading)
                }
                .padding(20)
                
            }
            
            VStack {
                
                ForEach(word.translate, id: \.self) { translate in
                    Text(translate)
                }
                
                ForEach(word.examples, id: \.self) { example in
                    Text(example)
                }
            }
            
            Spacer()
            
            DismissButton()
        }
        .navigationBarBackButtonHidden(true)
        
        .onAppear {
            
        }
    }
}

struct WordDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WordDetailView(word: .MOCK_DICTIONARY)
    }
}
