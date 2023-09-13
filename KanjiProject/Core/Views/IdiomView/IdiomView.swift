//
//  IdiomView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/29.
//

import SwiftUI

struct IdiomView: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        VStack {
            
            IdiomViewHeader(title: "四字熟語")
//                .frame(height: 230)
                .padding(.bottom, Settings.spacingBetweenIdiomHeaderAndElements)
            
            ScrollView(showsIndicators: false) {
                ForEach(store.yojijukugoStore.getAll()) { row in
                    HStack {
                        Text(row.body)
                        Text(row.reading)
                        Spacer()
                    }
                    .padding(.horizontal, Settings.padding)
                }
            }
                
                Spacer()
            
            Color.gray.ignoresSafeArea()
                .modifier(Modifiers.tabBarSize)
        }
    }
}

struct IdiomView_Previews: PreviewProvider {
    static var previews: some View {
        IdiomView()
            .environmentObject(Store())
    }
}
