//
//  KanjiLearningView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/06/14.
//

import SwiftUI

struct KanjiLearningView: View {
    @EnvironmentObject private var store: Store
    @Environment(\.dismiss) private var dismiss
    @State var currentKanji: KanjiKankenModel?
    let selectedKanken: Bool
    let nouryokuLevel: NouryokuLevel
    let kankenLevel: KankenLevel
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Button(action: {
                        Task {
                            await store.kanjiKankenStore.saveInFileManager()
                        }
                        dismiss()
                    }, label: {
                        ButtonsImages.dismissButtonImage
                            .resizable()
                            .frame(width: ElementSize.xmarkSize.width,
                                   height: ElementSize.xmarkSize.height)
                            .foregroundStyle(.black)
                            .opacity(0.4)
                    })
                    Spacer()
                }
                
                if let currentKanji = currentKanji {
                    HStack {
                        Text(currentKanji.body)
                            .font(.system(size: TextSizes.kanjiSize))
                            .padding(.horizontal, 5)
                            .border(Color.black, width: 1)
                            .padding(.leading, Settings.padding)
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
            .padding([.horizontal, .top], Settings.padding)
            .ignoresSafeArea(.container, edges: .top)
        }
        
        HStack(spacing: 0) {
            Button(action: {
                
            }, label: {
                    HStack {
                        ButtonsImages.wordListImage
                        Text("Записать")
                    }
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .foregroundStyle(.black)
                    .background {
                        Color.cyan
                            .ignoresSafeArea()
                            .opacity(0.35)
                    }
                })
                
            Button(action: {
                knowingButton()
                
            }, label: {
                HStack {
                    ButtonsImages.checkmark
                    Text("Знаю")
                }
                .frame(maxWidth: .infinity, maxHeight: 40)
                .foregroundStyle(.black)
                .background {
                    Color.green
                        .ignoresSafeArea()
                        .opacity(0.35)
                }
            })
                
            }
            .font(.title2)
    }
    func knowingButton() {
        guard var currentKanji = currentKanji  else { return }
        currentKanji.answer(set: true)
        self.currentKanji = currentKanji
        store.kanjiKankenStore.update(set: currentKanji)
        
        setCurrentKanji()
    }
    
    func setCurrentKanji() {
        currentKanji = getKanji()
    }
    
    func getKanji() -> KanjiKankenModel? {
        var allCurrentLevelKanji = store.kanjiKankenStore.getAllKanji(below: nouryokuLevel)
        allCurrentLevelKanji = allCurrentLevelKanji.filter { !($0.lastAnswer() ?? false) }
        return allCurrentLevelKanji.randomElement()
    }
}

#Preview {
    KanjiLearningView(currentKanji: .MOCK_KANJIKANKEN, selectedKanken: false, nouryokuLevel: .another, kankenLevel: .none)
        .environmentObject(Store())
}
