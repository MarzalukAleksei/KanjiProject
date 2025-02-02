//
//  BoldDivider.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2025/01/12.
//

import SwiftUI

struct BoldDivider: View {
    enum Position {
        case horizontal, vertical
    }
    private let position: Position
    private let depth: CGFloat
    private let opacity: Double
    
    init(position: Position = .horizontal, opacity: Double = 0.5, depth: CGFloat) {
        self.position = position
        self.opacity = opacity
        self.depth = depth
    }
    
    var body: some View {
        Group {
            if position == .horizontal {
                Rectangle()
                    .frame(maxHeight: depth)
            } else {
                Rectangle()
                    .frame(maxWidth: depth)
            }
        }
        .opacity(opacity)
    }
}

#Preview {
    BoldDivider(depth: 1)
}

