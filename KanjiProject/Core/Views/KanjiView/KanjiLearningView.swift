//
//  KanjiLearningView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/06/18.
//

import SwiftUI

struct KanjiLearningView: View {
    @EnvironmentObject private var store: Store
    @EnvironmentObject private var globalChanging: GlobalChanging
    @Environment(\.dismiss) private var dismiss
    @State var currentKanji: KanjiKankenModel?
    @State private var showWordDetail = false
    let selectedKanken: Bool
    let nouryokuLevel: NouryokuLevel
    let kankenLevel: KankenLevel
    
    var body: some View {
        VStack {
            VStack {
                CloseButton {
                    globalChanging.exampleWord = nil
                }
                
                if let currentKanji = currentKanji {
                    HStack(spacing: 50) {
                        Text(currentKanji.body)
                            .font(.system(size: TextSizes.kanjiSize))
                            .padding(.horizontal, TextSizes.kanjiSize * 0.3 / 2)
                            .border(Color.black, width: 1)
                            .padding(.leading, Settings.padding)
                        
                        Spacer()
                    }
                    KanjiDetailView(currentKanji: currentKanji, showImage: .constant(false))
                } else {
                    ProgressView()
                        .onAppear {
                            setCurrentKanji()
                            Task {
                                print("\nОсталось изучить \(findExpectedKanjiArray().count) Кандзи")
                            }
                        }
                }
                Spacer()
                
            }
            .padding([.horizontal, .top], Settings.closeButtonPadding)
            .ignoresSafeArea(.container, edges: .top)
            
            Button(action: {
                setCurrentKanji()
                globalChanging.exampleWord = nil
            }, label: {
                HStack {
                    ButtonsImages.updateImage
                        .resizable()
                        .frame(width: ElementSize.bottomButtonImage.width,
                               height: ElementSize.bottomButtonImage.height)
                }
                .modifier(Modifiers.learningNextButton)
            })
            .font(.title2)
            
        }
        .overlay {
            if showWordDetail {
                SelectedWordDetailView()
            }
        }
        .onReceive(globalChanging.$exampleWord, perform: { word in
            if word != nil {
                showWordDetail = true
            } else {
                showWordDetail = false
            }
        })
        
    }
    
    private func setCurrentKanji() {
        currentKanji = getKanji()
    }
    
    private func getKanji() -> KanjiKankenModel? {
        return findExpectedKanjiArray().randomElement()
    }
    
    private func findExpectedKanjiArray() -> [KanjiKankenModel] {
        var allCurrentLevelKanji = store.kanjiKankenStore.getAllKanji(below: nouryokuLevel)
        allCurrentLevelKanji = allCurrentLevelKanji
            .filter { !($0.lastAnswer() ?? false) }
            .filter { $0.inLearningList() }
        return allCurrentLevelKanji
    }
}

#Preview {
    KanjiLearningView(currentKanji: .MOCK_KANJIKANKEN, selectedKanken: false, nouryokuLevel: .N5, kankenLevel: .none)
        .environmentObject(Store())
        .environmentObject(GlobalChanging())
}
