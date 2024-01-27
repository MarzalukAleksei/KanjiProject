//
//  CashImage.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/01/27.
//

import SwiftUI

class CacheImage {
    
    private func fileDirectory(directoryName: String) -> URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
//        let fileURL = documentsDirectory.appendingPathComponent("myImage.jpg")
        // Вместо "myImage.jpg" Можно использовать имя, которое соответствует изображению.
        let customFolderURL = documentsDirectory.appending(path: directoryName)
        //        return fileURL
        return customFolderURL
    }
    
    func saveImage(image: UIImage?, fileName: String) {
        let url = fileDirectory(directoryName: "CacheImages")
        guard let image = image,
              let data = image.jpegData(compressionQuality: 1.0),
              let fileURL = url else { return }
            do {
                try FileManager.default.createDirectory(at: fileURL, withIntermediateDirectories: true, attributes: nil)
                let file = fileURL.appendingPathComponent(fileName, conformingTo: .gif)

                print(fileURL)
                try data.write(to: file)
            } catch {
                print("Ошибка при сохранении изображения: \(error)")
            }
        
    }
    
    func loadImage(fileName: String) -> UIImage? {
        let url = fileDirectory(directoryName: "CacheImages")
        guard let fileURL = url else { return nil }

        let imagePath = fileURL.appendingPathComponent("\(fileName).gif").path
        return UIImage(contentsOfFile: imagePath)
    }
    
    func saveImages(array: [KanjiKankenModel]) async {
        struct Pair {
            let body: String
            let image: UIImage
        }
        
        let _: () = await withTaskGroup(of: Pair.self) { taskGroup in
            for kanji in array {
                taskGroup.addTask {
                    let parse = Parse(kanji: kanji)
                    guard let url = await URL(string: parse.kanjiImageLink()),
                          let uiImage = await UIImage(data: parse.getUIImageData(url)) else {
                        return Pair(body: "", image: UIImage())
                    }
                    return Pair(body: kanji.body, image: uiImage)
                }
            }
            
            var resultImages: [Pair] = []
            
            for await task in taskGroup {
                resultImages.append(task)
            }
            
            // Дальнейшая обработка полученных изображений или сохранение
            for image in resultImages {
                CacheImage().saveImage(image: image.image, fileName: "\(image.body)")
            }
        }
    }
}
