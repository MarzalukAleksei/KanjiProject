//
//  PartialRoundedRectangle.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/07.
//

import SwiftUI

struct PartialRoundedRectangle: Shape {
    let cornerRadius: CGFloat
    let corners: UIRectCorner // Это массив

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let topLeftRadius: CGFloat = corners.contains(.topLeft) ? cornerRadius : 0
        let topRightRadius: CGFloat = corners.contains(.topRight) ? cornerRadius : 0
        let bottomLeftRadius: CGFloat = corners.contains(.bottomLeft) ? cornerRadius : 0
        let bottomRightRadius: CGFloat = corners.contains(.bottomRight) ? cornerRadius : 0
        
        path.addArc(center: CGPoint(x: rect.minX + topLeftRadius, y: rect.minY + topLeftRadius),
                    radius: topLeftRadius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        
        path.addArc(center: CGPoint(x: rect.maxX - topRightRadius, y: rect.minY + topRightRadius), radius: topRightRadius, startAngle: .degrees(270), endAngle: .degrees(360), clockwise: false)
        
        path.addArc(center: CGPoint(x: rect.maxX - bottomRightRadius, y: rect.maxY - bottomRightRadius), radius: bottomRightRadius, startAngle: .degrees(360), endAngle: .degrees(90), clockwise: false)
        
        path.addArc(center: CGPoint(x: rect.minX + bottomLeftRadius, y: rect.maxY - bottomLeftRadius), radius: bottomLeftRadius, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)

        return path
    }
}
