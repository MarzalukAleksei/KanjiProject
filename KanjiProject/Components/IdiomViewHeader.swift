//
//  IdiomViewHeader.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/29.
//

import SwiftUI

struct IdiomViewHeader: View {
    let title: String
    var body: some View {
        ZStack {
//            Color.black.ignoresSafeArea()
//                .frame(height: 0)
            Group {
                LinesView()
                    .frame(height: 200)
                    .offset(CGSize(width: -5, height: -30))
                    .overlay(alignment: .top) {
                        HStack {
                            Spacer()
                            
                            Text(title)
                                .font(.largeTitle)
                                .foregroundColor(.white)
                            
                            Spacer()
                            Spacer()
                        }
                    }
                
                
                LinesView()
                    .offset(CGSize(width: 14, height: -10))
                    .stroke(lineWidth: 1)
                    .frame(height: 210)
            }
        }
    }
}

struct IdiomViewHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            IdiomViewHeader(title: "四字熟語")
            Spacer()
        }
    }
}
