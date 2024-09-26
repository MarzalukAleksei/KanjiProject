//
//  KanjiCheckView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/06/14.
//

import SwiftUI

struct KanjiCheckView: View {
    @EnvironmentObject private var store: Store
    @EnvironmentObject private var globalChanging: GlobalChanging
    @Environment(\.dismiss) private var dismiss
    @State var currentKanji: KanjiKankenModel?
    let selectedKanken: Bool
    let nouryokuLevel: NouryokuLevel
    let kankenLevel: KankenLevel
    
    var body: some View {
        VStack {
            VStack {
                CloseButton {
                    globalChanging.exampleWord = nil
                    Task {
                        await store.kanjiKankenStore.saveInFileManager()
                    }
                }
                
                if let currentKanji = currentKanji {
                    HStack(spacing: 50) {
                        Text(currentKanji.body)
                            .font(.system(size: TextSizes.kanjiSize))
                            .padding(.horizontal, TextSizes.kanjiSize * 0.3 / 2)
                            .border(Color.black, width: 1)
                            .padding(.leading, Settings.padding)
                        
//                        KanjiImageView(currentKanji: currentKanji)
//                            .frameSize(width: TextSizes.kanjiSize, height: TextSizes.kanjiSize)
                        
                        Spacer()
                    }
                    KanjiDetailView(currentKanji: currentKanji, showImage: .constant(false))
                } else {
                    ProgressView()
                        .onAppear {
//                            let kanjiStore = store.kanjiKankenStore.getAll().map { kanji in
//                                var kanji = kanji
//                                kanji.answer(set: nil)
//                                return kanji
//                            }
//                            store.kanjiKankenStore.updateAll(data: kanjiStore)
                            setCurrentKanji()
                        }
                }
                Spacer()
                
            }
            .padding([.horizontal, .top], Settings.closeButtonPadding)
            .ignoresSafeArea(.container, edges: .top)
        }
        
        HStack(spacing: 0) {
            Button(action: {
                addInList()
            }, label: {
                    HStack {
                        ButtonsImages.wordListImage
                            .resizable()
                            .frame(width: ElementSize.bottomButtonImage.width,
                                   height: ElementSize.bottomButtonImage.height)
                        Text("Записать")
                            .font(.system(size: TextSizes.bottomButtonsText))
                    }
                    .modifier(Modifiers.inListButton)
                })
                
            Button(action: {
                knowingButton()
                
            }, label: {
                HStack {
                    ButtonsImages.checkmark
                        .resizable()
                        .frame(width: ElementSize.bottomButtonImage.width,
                               height: ElementSize.bottomButtonImage.height)
                    Text("Пропустить")
                        .font(.system(size: TextSizes.bottomButtonsText))
                }
                .modifier(Modifiers.skipButton)
            })
                
            }
            .font(.title2)
    }
    
    private func addInList() {
        guard var currentKanji = currentKanji else { return }
        currentKanji.learning()
        currentKanji.setAnswer(with: false)
        store.kanjiKankenStore.update(set: currentKanji)
        
        setCurrentKanji()
    }
    
    private func knowingButton() {
        guard var currentKanji = currentKanji  else { return }
        currentKanji.setAnswer(with: true)
        currentKanji.setRightAnswer()
        self.currentKanji = currentKanji
        store.kanjiKankenStore.update(set: currentKanji)
        
        setCurrentKanji()
    }
    
    private func setCurrentKanji() {
        currentKanji = getKanji()
    }
    
    private func getKanji() -> KanjiKankenModel? {
        var allCurrentLevelKanji = store.kanjiKankenStore.getAllKanji(below: nouryokuLevel)
        allCurrentLevelKanji = allCurrentLevelKanji
            .filter { !($0.showlastAnswer() ?? false) }
            .filter { !($0.isInLearningList() ?? false) }
//        allCurrentLevelKanji = allCurrentLevelKanji.filter { !$0.inLearningList() }
        return allCurrentLevelKanji.randomElement()
    }
}

#Preview {
    KanjiCheckView(currentKanji: .MOCK_KANJIKANKEN, selectedKanken: false, nouryokuLevel: .another, kankenLevel: .none)
        .environmentObject(Store())
        .environmentObject(GlobalChanging())
}
