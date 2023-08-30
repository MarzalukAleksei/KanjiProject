//
//  LinesView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/28.
//

import SwiftUI

struct LinesView: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
//        path.move(to: CGPoint(x: width, y: height * 0.05))
        path.move(to: CGPoint(x: width, y: -70))
        
        path.addCurve(to: CGPoint(x: width * 0.8,
                                  y: height * 0.32),
                      control1: CGPoint(x: width * 0.7,
                                        y: height * 0.13),
                      control2: CGPoint(x: width * 0.75,
                                        y: height * 0.2))
        path.addCurve(to: CGPoint(x: width * 0.6,
                                  y: height * 0.46),
                      control1: CGPoint(x: width * 0.85,
                                        y: height * 0.43),
                      control2: CGPoint(x: width * 0.65,
                                        y: height * 0.45))
        path.addCurve(to: CGPoint(x: width * 0.21,
                                  y: height * 0.36),
                      control1: CGPoint(x: width * 0.3,
                                        y: height * 0.5),
                      control2: CGPoint(x: width * 0.35,
                                        y: height * 0.12))
        path.addCurve(to: CGPoint(x: -20,
                                  y: height * 0.65),
                      control1: CGPoint(x: width * 0.12,
                                        y: height * 0.6),
                      control2: CGPoint(x: width * 0.01,
                                        y: height * 0.6))
        
        
        path.addLine(to: CGPoint(x: -20, y: -70))
        
        return path
    }
    
}

struct LinesView_Previews: PreviewProvider {
    static var previews: some View {
        LinesView()
            .frame(width: 300, height: 300)
//            .foregroundColor(.blue)
    }
}
