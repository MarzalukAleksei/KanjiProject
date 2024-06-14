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

    var body: some View {
        ZStack {
            if let image = image {
                image
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width - Settings.padding * 2, height: UIScreen.main.bounds.width - Settings.padding * 2)
            } else {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: UIScreen.main.bounds.width - Settings.padding * 2, height: UIScreen.main.bounds.width - Settings.padding * 2)
                    case .success(let image):
                        image
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width - Settings.padding * 2, height: UIScreen.main.bounds.width - Settings.padding * 2)
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
