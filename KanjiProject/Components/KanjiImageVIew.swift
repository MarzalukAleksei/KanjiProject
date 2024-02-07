//
//  KanjiImageVIew.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/01/27.
//

import SwiftUI

struct KanjiImageVIew: View {
    let kanjiArray: [KanjiKankenModel]
    @Binding var currentIndex: Int
    @State var image: Image?
    @State var url: URL?
    var body: some View {
        ZStack {
            if let image = image {
                image
                    .resizable()
                    .frame(width: (UIScreen.current?.bounds.width ?? 0) - Settings.padding * 2, height: (UIScreen.current?.bounds.width ?? 0) - Settings.padding * 2)
            } else {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: (UIScreen.current?.bounds.width ?? 0) - Settings.padding * 2, height: (UIScreen.current?.bounds.width ?? 0) - Settings.padding * 2)
                    case .success(let image):
                        image
                            .resizable()
                            .frame(width: (UIScreen.current?.bounds.width ?? 0) - Settings.padding * 2, height: (UIScreen.current?.bounds.width ?? 0) - Settings.padding * 2)
                    case .failure(_):
                        EmptyView()
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        }
        .onAppear {
            loadImage()
            if CacheImage().loadImage(fileName: kanjiArray[currentIndex].body) == nil {
                loadAllBlockImages()
            }
        }
        .onChange(of: currentIndex, perform: { value in
            withAnimation(Settings.animation) {
                loadImage()
            }
        })
    }
    
    func loadAllBlockImages() {
        Task {
            await CacheImage().saveImages(array: kanjiArray)
        }
    }
    
    func loadImage() {
        url = nil
        setImage()
        if image == nil {
            Task {
                await parse()
            }
        }
        
        func setImage() {
            if let uiImage = CacheImage().loadImage(fileName: kanjiArray[currentIndex].body) {
                self.image = Image(uiImage: uiImage)
            } else {
                self.image = nil
            }
        }
    }
    
    func parse() async {
        let parse = Parse(kanji: kanjiArray[currentIndex])
        guard let url = await URL(string: parse.kanjiImageLink()) else { return }
        self.url = url
        let uiImage = await UIImage(data: parse.getUIImageData(url))
        CacheImage().saveImage(image: uiImage, fileName: kanjiArray[currentIndex].body)
    }
}

#Preview {
    KanjiImageVIew(kanjiArray: [.MOCK_KANJIKANKEN, .ANOTHER_MOCK_KANKENKANJI], currentIndex: .constant(0))
}
