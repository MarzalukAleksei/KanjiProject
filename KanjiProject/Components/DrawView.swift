//
//  DrawView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/10/31.
//

import SwiftUI

struct DrawView: View {
    @Binding var path: Path
    @State private var startPoint: CGPoint = .zero
    @State var image = UIImage()
    let size: CGSize
    
    var body: some View {
        ZStack {
            MainRect(size: CGSize(width: size.width, height: size.height))
            Canvas(path: $path)
                .frame(width: size.width, height: size.height)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let currentPoint = value.location
                            if currentPoint.x >= 0, currentPoint.x <= size.width,
                               currentPoint.y >= 0, currentPoint.y <= size.height {
                                if startPoint == .zero {
                                    startPoint = currentPoint
                                    path.move(to: startPoint) // Устанавливаем начальную точку
                                }
                                path.addLine(to: currentPoint)
                            }
                        }
                        .onEnded { _ in
                            startPoint = .zero
                            
                        }
                )
        }
        .frame(width: size.width, height: size.height)
    }
    
    private func createImageFromPath(_ path: Path, size: CGSize) -> UIImage? {
        let size = CGSize(width: size.width, height: size.height) // Размер изображения, соответствующий размеру Canvas
        return UIGraphicsImageRenderer(size: size).image { ctx in
            UIColor.white.setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
            UIColor.red.setStroke()
            ctx.cgContext.setLineWidth(5)
            ctx.cgContext.addPath(path.cgPath)
            ctx.cgContext.strokePath()
        }
    }
}

// Создается отдельным вью из-за того, что точка рисования начинается с рамки. рисовать внутри невозможно
private struct MainRect: View {
    let size: CGSize
    
    var body: some View {
        ZStack {
            Rectangle()
                .stroke(lineWidth: 2)
            Group {
                Rectangle()
                    .frame(width: 1)
                Rectangle()
                    .frame(height: 1)
            }
            .opacity(Settings.opacity)
        }
        .frame(width: size.width, height: size.height)
    }
}

// Создается над квадратом для рисования
private struct Canvas: View {
    @Binding var path: Path
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.white)
                .opacity(0.0001) // используется чтобы сделать вью прозрачным, т.к если сделать его прозрачным с помощью .clear аналогично невозможно будет рисовать
            path.stroke(.black, lineWidth: 5)
        }
    }
}

#Preview {
    DrawView(path: .constant(Path()), size: CGSize(width: 300, height: 300))
}
