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
                                  y: height * 0.52),
                      control1: CGPoint(x: width * 0.7,
                                        y: height * 0.33),
                      control2: CGPoint(x: width * 0.75,
                                        y: height * 0.4))
        path.addCurve(to: CGPoint(x: width * 0.6,
                                  y: height * 0.66),
                      control1: CGPoint(x: width * 0.85,
                                        y: height * 0.63),
                      control2: CGPoint(x: width * 0.65,
                                        y: height * 0.65))
        path.addCurve(to: CGPoint(x: width * 0.21,
                                  y: height * 0.56),
                      control1: CGPoint(x: width * 0.3,
                                        y: height * 0.7),
                      control2: CGPoint(x: width * 0.35,
                                        y: height * 0.32))
        path.addCurve(to: CGPoint(x: -20,
                                  y: height),
                      control1: CGPoint(x: width * 0.12,
                                        y: height * 0.8),
                      control2: CGPoint(x: width * 0.01,
                                        y: height * 0.8))
        
        
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
