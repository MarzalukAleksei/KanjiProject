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
//            Group {
                LinesView()
                    .frame(height: 200)
                    .offset(CGSize(width: 5, height: -30))
                    .rotation3DEffect(Angle(degrees: 180), axis: (x: 0, y: 1, z: 0))
                    .overlay(alignment: .top) {
                        HStack {
                            Spacer()
                            Spacer()
                            
                            Text(title)
                                .font(.largeTitle)
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                    }
                
                
                LinesView()
                    .offset(CGSize(width: 24, height: -13))
                    .stroke(lineWidth: 1)
                    .frame(height: 210)
                    .rotation3DEffect(Angle(degrees: 180), axis: (x: 0, y: 1, z: 0))
                    .rotationEffect(Angle(degrees: 1))
//            }
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
