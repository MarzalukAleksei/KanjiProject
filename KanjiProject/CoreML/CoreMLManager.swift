//
//  CoreMLManager.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/11/03.
//

import SwiftUI
import UIKit
import CoreML
//import Vision

class CoreMLManager {
    
    private func createImageFromPath(_ path: Path, size: CGSize) -> UIImage? {
        let size = CGSize(width: size.width, height: size.height) // Размер изображения, соответствующий размеру Canvas
        let uiImage =  UIGraphicsImageRenderer(size: size).image { ctx in
            UIColor.white.setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
            UIColor.red.setStroke()
            ctx.cgContext.setLineWidth(5)
            ctx.cgContext.addPath(path.cgPath)
            ctx.cgContext.strokePath()
        }
//        return Image(uiImage: uiImage)
        return uiImage
    }
    
    func getPrediction(path: Path) {
        if let model = try? KanjiClassificator(configuration: .init()) {
            // Теперь у вас есть экземпляр модели, готовый для выполнения предсказаний
            print("Sucsess")
            print(model)
            guard let uiImage = createImageFromPath(path, size: CGSize(width: 299, height: 299)),
            let pixelBuffer = imageToPixelBuffer(uiImage) else { return }
            let input = KanjiClassificatorInput(image: pixelBuffer)
            print(input)
            
            do {
                let prediction = try model.prediction(input: input)
                let i = prediction.targetProbability
                let filtered = i.filter { $0.value > 0.01 }
                let result = filtered.values.sorted(by: { a, b in
                    a < b
                })
                print(filtered)
                print(result)
                print(i.count)
            } catch {
                print(error)
            }
        }
    }
    
    func imageToPixelBuffer(_ image: UIImage?) -> CVPixelBuffer? {
        // Создайте контейнер для изображения
        var pixelBuffer: CVPixelBuffer?
        
        // Используйте UIKit для получения UIImage из SwiftUI Image
        if let uiImage = image {
            // Создайте контейнер для изображения
            let attributes: [CFString: Any] = [
                kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue!,
                kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue!
            ]
            let width = Int(uiImage.size.width)
            let height = Int(uiImage.size.height)
            
            CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32ARGB, attributes as CFDictionary, &pixelBuffer)
            
            if let pixelBuffer = pixelBuffer {
                // Запишите изображение в CVPixelBuffer
                CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
                let context = CIContext()
                
                context.render(CIImage(cgImage: uiImage.cgImage!), to: pixelBuffer)
                
                CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
                
                return pixelBuffer
            }
        }
        
        return nil
    }
    
}
