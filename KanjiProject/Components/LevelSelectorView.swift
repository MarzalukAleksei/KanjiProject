//
//  LevelSelectorView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/11/03.
//

import SwiftUI

struct LevelSelectorView: View {
//    @Binding var selectedType: KanjiTestType
    @AppStorage("selectedKankenLevel") var selectedKankenLevel: KankenLevel = .none
    @AppStorage("selectedNouryokuLevel") var selectedNouryokuLevel: NouryokuLevel = .N5
    @AppStorage("bushuuSelected") var isBushuSelected: Bool = false
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
                            BushuButton(store: store, isBushuSelected: $isBushuSelected, selectedKankenLevel: $selectedKankenLevel)
                            
                            KankenButtons(proxy: proxy, store: store, selectedKankenLevel: $selectedKankenLevel, isBushuSelected: $isBushuSelected)
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

fileprivate struct BushuButton: View {
    let store: Store
    @Binding var isBushuSelected: Bool
    @Binding var selectedKankenLevel: KankenLevel
    var body: some View {
        Text("")
        LevelButton(labelName: "部首",
                    array: store.bushuStore.getAll(),
                    size: CGSize(width: ElementSize.levelButtonSize.width,
                                 height: ElementSize.levelButtonSize.height),
                    color: isBushuSelected == true ? Settings.selectedColor : Settings.diselectedColor)
        .onTapGesture {
            withAnimation(Settings.animation) {
                isBushuSelected = true
                selectedKankenLevel = .none
            }
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
                LevelButton(labelName: level,
                            array: kanjiArray,
                            size: CGSize(width: ElementSize.levelButtonSize.width,
                                         height: ElementSize.levelButtonSize.height),
                            color: selectedLevel == level ? Settings.selectedColor : Settings.diselectedColor)
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
    @Binding var isBushuSelected: Bool
    var body: some View {
        ForEach(KankenLevel.allCases.reversed(), id: \.self) { level in
            if level != .none {
                let kankenArray = store.kanjiKankenStore.get(kankenLevel: level)
                LevelButton(labelName: level,
                            array: kankenArray,
                            size: CGSize(width: ElementSize.levelButtonSize.width,
                                         height: ElementSize.levelButtonSize.height),
                            color: selectedKankenLevel == level ? Settings.selectedColor : Settings.diselectedColor)
                .onTapGesture {
                    withAnimation(Settings.animation) {
                        selectedKankenLevel = level
                        scrollTo(proxy: proxy)
                        isBushuSelected = false
                    }
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
