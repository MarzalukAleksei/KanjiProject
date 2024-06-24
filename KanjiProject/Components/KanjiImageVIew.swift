//
//  KanjiImageVIew.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/01/27.
//

import SwiftUI

struct KanjiImageView: View {
    let currentKanji: KanjiKankenModel
    @State private var image: Image?
    @State private var url: URL?
    private let width: CGFloat
    private let height: CGFloat
    
    init(currentKanji: KanjiKankenModel, image: Image? = nil, url: URL? = nil) {
        self.currentKanji = currentKanji
        self.image = image
        self.url = url
        self.width = UIScreen.main.bounds.width - Settings.padding * 2
        self.height = UIScreen.main.bounds.width - Settings.padding * 2
    }
    
    private init(currentKanji: KanjiKankenModel, image: Image? = nil, url: URL? = nil, width: CGFloat, height: CGFloat) {
        self.currentKanji = currentKanji
        self.image = image
        self.url = url
        self.width = width
        self.height = height
    }

    var body: some View {
        ZStack {
            if let image = image {
                image
                    .resizable()
                    .frame(width: width, height: height)
            } else {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: width, height: height)
                    case .success(let image):
                        image
                            .resizable()
                            .frame(width: width, height: height)
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
        }
        .onChange(of: currentKanji) { newKanji in
            loadImage(for: newKanji)
        }
    }
    
    func frameSize(width: CGFloat, height: CGFloat) -> some View {
        KanjiImageView(currentKanji: currentKanji, width: width, height: height)
    }
    
    private func loadImage(for kanji: KanjiKankenModel? = nil) {
        let kanjiToLoad = kanji ?? currentKanji
        url = nil
        setImage(for: kanjiToLoad)
        if image == nil {
            Task {
                await parse(for: kanjiToLoad)
            }
        }
    }

    private func setImage(for kanji: KanjiKankenModel) {
        if let uiImage = CacheImage().loadImage(fileName: kanji.body) {
            self.image = Image(uiImage: uiImage)
        } else {
            self.image = nil
        }
    }

    private func parse(for kanji: KanjiKankenModel) async {
        let parse = Parse()
        guard let url = await URL(string: parse.kanjiImageLink(kanji: kanji)) else { return }
        self.url = url
        if let uiImage = await UIImage(data: parse.getUIImageData(url)) {
            CacheImage().saveImage(image: uiImage, fileName: kanji.body)
            Task {
                self.image = Image(uiImage: uiImage)
            }
        }
    }
}

#Preview {
    KanjiImageView(currentKanji: .MOCK_KANJIKANKEN)
}
