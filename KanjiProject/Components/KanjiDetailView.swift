//
//  KanjiDetailView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/06/14.
//

import SwiftUI

struct KanjiDetailView: View {
    let currentKanji: KanjiKankenModel
//    @State private var mockIndex: Int = 0
    @Binding var showImage: Bool
    
    init(currentKanji: KanjiKankenModel, showImage: Binding<Bool> = .constant(true)) {
        self.currentKanji = currentKanji
        self._showImage = showImage
    }
    
//    init(currentKanji: KanjiKankenModel) {
//        self.currentKanji = currentKanji
//        self._showImage = .constant(true)
//    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: Settings.paddingBetweenText) {
                    ForEach(SchoolLevel.allCases, id: \.self) { type in
                        if let row = getKunReading(type) {
                            KankenReadingRowView(row: row, type: type)
                        }
                    }
                    
                    ForEach(SchoolLevel.allCases, id: \.self) { type in
                        if let row = getOnReading(type) {
                            KankenReadingRowView(row: row, type: type)
                        }
                    }
                }
                .id(0) // MARK: Устанавливаем id для скроллинга
                
                // MARK: Отображение значения кандзи на русском
                if let meaningInRussion = currentKanji.meaningInRussion {
                    Divider()
                    
                    Text(meaningInRussion.uppercased())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, Settings.padding)
                }
                
                Divider()
                
                // MARK: Значание на японском
                HStack {
                    Text(currentKanji.meaning)
                    Spacer()
                }
                .padding(.horizontal, Settings.padding)
                
                Divider()
                
                // MARK: Примеры
                KanjiExamplesRowView(currentKankenKanji: currentKanji)
                
                Divider()
                
                // MARK: Пишет сообщение о уровне JLPT
                if let nouryokuLevel = currentKanji.nouryokuLevel {
                    Text("Данный кандзи входит в список JLPT \(nouryokuLevel)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, Settings.padding)
                    
                    Divider()
                }
                
                // MARK: Изображение, подгружаемое из сети
                if showImage {
                    KanjiImageView(currentKanji: currentKanji)
                }
            }
            .scrollIndicators(.hidden)
            
        }
    }
    
    func getKunReading(_ type: SchoolLevel) -> String? {
        return currentKanji.kunReading[type]
    }
    
    func getOnReading(_ type: SchoolLevel) -> String? {
        return currentKanji.onReading[type]
    }
    
    func scrollTo(proxy: ScrollViewProxy) {
        withAnimation(Settings.scrollAnimation) {
            proxy.scrollTo(0, anchor: .top)
        }
    }
    
}

#Preview {
    KanjiDetailView(currentKanji: .MOCK_KANJIKANKEN)
}
