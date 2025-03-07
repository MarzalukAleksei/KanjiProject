//
//  KanjiDetailView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/06/14.
//

import SwiftUI

struct KanjiDetailView: View {
    @EnvironmentObject var userSettings: UserSettings
    let currentKanji: KanjiKankenModel
//    @State private var mockIndex: Int = 0
    @Binding var showImage: Bool
    var action: (_ hideReadings: Bool) -> Void
    @Binding var hideKanjiReadings: Bool
    let tapEnable: Bool
    
    init(currentKanji: KanjiKankenModel, showImage: Binding<Bool> = .constant(true), action: @escaping (_ hideReadings: Bool) -> Void ) {
        self.currentKanji = currentKanji
        self._showImage = showImage
        self._hideKanjiReadings = .constant(true)
        self.action = action
        self.tapEnable = true
    }
    
    init(currentKanji: KanjiKankenModel, showImage: Binding<Bool> = .constant(true) ) {
        self.currentKanji = currentKanji
        self._showImage = showImage
        self._hideKanjiReadings = .constant(false)
        self.action = { _ in }
        self.tapEnable = false
    }
    
    init(currentKanji: KanjiKankenModel, showImage: Binding<Bool> = .constant(true), hideKanji: Binding<Bool>) {
        self.currentKanji = currentKanji
        self._showImage = showImage
        self._hideKanjiReadings = hideKanji
        self.action = { _ in }
        self.tapEnable = false
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                KanjiReadings(currentKanji: currentKanji, hideKanjiReadings: $hideKanjiReadings)
                .overlay(content: {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            // MARK: Сначала происходит смена значения, а после только передается.
                            if tapEnable {
                                hideKanjiReadings.toggle()
                                action(hideKanjiReadings)
                            }
                        }
                })
                .id(0) // MARK: Устанавливаем id для скроллинга
                
                // MARK: Отображение значения кандзи на русском
                if let meaningInRussion = currentKanji.meaningInRussion {
//                    Divider()
                    Meaning(groupName: "[RU]", meaning: meaningInRussion)
                    
                    Divider()
                }
                
                // MARK: Отображение значения кандзи на английском
                if let meaningInEng = currentKanji.meaningInEng, userSettings.showEnglishMeaning {
                    Meaning(groupName: "[EN]", meaning: meaningInEng)
                    
                    Divider()
                }
                
                // MARK: Отображение значения кандзи на японском
                Meaning(groupName: "[JP]", meaning: currentKanji.meaning)
                
                BoldDivider(depth: Settings.boldDividerDepth)
                
                // MARK: Примеры
                KanjiExamplesRowView(currentKankenKanji: currentKanji)
                    .padding(.bottom, Settings.paddingBetweenText)
                
                BoldDivider(depth: Settings.boldDividerDepth)
                
                // MARK: Изображение, подгружаемое из сети
                if showImage {
                    KanjiImageView(currentKanji: currentKanji)
                        .padding(.bottom, 50)
                } else {
                    Color.clear
                        .frame(height: 50)
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
        .environmentObject(UserSettings())
}

private struct TranslateSection: View {
    let groupName: String
    let translate: String
    
    var body: some View {
        HStack {
            Text(groupName)
                .frame(maxHeight: .infinity, alignment: .top)
            
            Text(translate)
        }
    }
}

private struct Meaning: View {
    let groupName: String
    let meaning: String
     
    var body: some View {
        HStack(spacing: 5) {
            Text(groupName)
                .font(.system(size: TextSizes.translation.tag))
                .frame(maxHeight: .infinity, alignment: .top)
            
            Text(meaning.uppercased())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, Settings.padding)
                .font(.system(size: TextSizes.translation.meaning))
        }
    }
}
