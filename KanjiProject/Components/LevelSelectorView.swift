//
//  LevelSelectorView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/11/03.
//

import SwiftUI

struct LevelSelectorView: View {
//    @Binding var selectedType: KanjiTestType
    @AppStorage("selectedNouryokuLevel") var selectedNouryokuLevel: NouryokuLevel = .N5
    @AppStorage("selectedKankenLevel") var selectedKankenLevel: KankenLevel = .級10
    @EnvironmentObject private var store: Store
    @Binding var toggle: Bool
    
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Settings.paddingBetweenElements) {
                    
                    if !toggle {
                        NouryokuButtons(proxy: proxy, store: store, selectedLevel: $selectedNouryokuLevel)
                    } else {
                        KankenButtons(proxy: proxy, store: store, selectedKankenLevel: $selectedKankenLevel)
                    }
                }
                .padding(.horizontal, Settings.padding)
            }
            .onAppear {
                withAnimation(Settings.animation) {
                    scrollTo(proxy: proxy)
                }
                
            }
        }
    }
    func scrollTo(proxy: ScrollViewProxy) {
        proxy.scrollTo(selectedNouryokuLevel, anchor: .center)
    }
}

fileprivate struct NouryokuButtons: View {
    let proxy: ScrollViewProxy
    let store: Store
    @Binding var selectedLevel: NouryokuLevel
    var body: some View {
        ForEach(NouryokuLevel.allCases.reversed(), id: \.self) { level in
            if level != .another {
                let kanjiArray = store.kanjiStore.getData(level)
                LevelButton(nouryokuLevelTitle: level,
                            nouryokuKanjiArray: kanjiArray,
                            size: CGSize(width: ElementSize.levelButtonSize.width,
                                         height: ElementSize.levelButtonSize.height),
                            color: selectedLevel == level ? .secondary : .black)
                .onTapGesture {
                    withAnimation(Settings.animation) {
                        selectedLevel = level
                        scrollTo(proxy: proxy)
                    }
            }
            }
            
        }
    }
    func scrollTo(proxy: ScrollViewProxy) {
        proxy.scrollTo(selectedLevel, anchor: .center)
    }
}

fileprivate struct KankenButtons: View {
    let proxy: ScrollViewProxy
    let store: Store
    @Binding var selectedKankenLevel: KankenLevel
    var body: some View {
        ForEach(KankenLevel.allCases.reversed(), id: \.self) { level in
            let kankenArray = store.kanjiKanken.getAll().filter { $0.kankenLevel == level }
            LevelButton(kankenLevelTitle: level,
                        kanjiKankenArray: kankenArray,
                        size: CGSize(width: ElementSize.levelButtonSize.width,
                                     height: ElementSize.levelButtonSize.height),
                        color: selectedKankenLevel == level ? .secondary : .black)
            .onTapGesture {
                withAnimation(Settings.animation) {
                    selectedKankenLevel = level
                    scrollTo(proxy: proxy)
                }
        }
        }
    }
    func scrollTo(proxy: ScrollViewProxy) {
        proxy.scrollTo(selectedKankenLevel, anchor: .center)
    }
}

#Preview {
    LevelSelectorView(toggle: .constant(false))
        .environmentObject(Store())
}

#Preview{
    LevelSelectorView(toggle: .constant(true))
        .environmentObject(Store())
}
