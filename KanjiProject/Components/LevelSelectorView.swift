//
//  LevelSelectorView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/11/03.
//

import SwiftUI

struct LevelSelectorView: View {
//    @Binding var selectedType: KanjiTestType
    @AppStorage("selectedKankenLevel") var selectedKankenLevel: KankenLevel = .級10
    @AppStorage("selectedNouryokuLevel") var selectedNouryokuLevel: NouryokuLevel = .N5
    @EnvironmentObject private var store: Store
    @Binding var toggle: Bool
    
    
    var body: some View {
        VStack {
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
//                .onAppear {
//                    withAnimation(Settings.animation) {
//                        scrollTo(proxy: proxy)
//                    }
//                    
//                }
                .onChange(of: toggle, perform: { value in
                    withAnimation(Settings.animation) {
                        scrollTo(proxy: proxy)
                    }
                })
            }
        }
    }
    func scrollTo(proxy: ScrollViewProxy) {
//        proxy.scrollTo(selectedNouryokuLevel, anchor: .center)
        if !toggle {
            proxy.scrollTo(selectedNouryokuLevel, anchor: .center)
        } else {
            proxy.scrollTo(selectedKankenLevel, anchor: .center)
        }
    }
}

fileprivate struct NouryokuButtons: View {
    let proxy: ScrollViewProxy
    let store: Store
    @Binding var selectedLevel: NouryokuLevel
    var body: some View {
        ForEach(NouryokuLevel.allCases.reversed(), id: \.self) { level in
            if level != .another {
                let kanjiArray = store.kanjiStore.get(level)
                LevelButton(level: level,
                            array: kanjiArray,
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
            let kankenArray = store.kanjiKanken.get(level: level)
            LevelButton(level: level,
                        array: kankenArray,
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
