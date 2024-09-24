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
    @State private var showDeleteWarning = false
    @State private var hideReadings: Bool = true
    
    let selectedKanken: Bool
    let nouryokuLevel: NouryokuLevel
    let kankenLevel: KankenLevel
    let min = 25
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    CloseButton {
                        globalChanging.exampleWord = nil
                        Task {
                            await store.kanjiKankenStore.saveInFileManager()
                        }
                    }
                    
                    Spacer()
                }
                
                if let currentKanji = currentKanji {
                    HStack(spacing: 50) {
                        Text(currentKanji.body)
                            .font(.system(size: TextSizes.kanjiSize))
                            .padding(.horizontal, TextSizes.kanjiSize * 0.3 / 2)
                            .border(Color.black, width: 1)
                            .padding(.leading, Settings.padding)
                            .onTapGesture {
                                showDeleteWarning = true
                            }
                        
                        Spacer()
                    }
                    
                    KanjiDetailView(currentKanji: currentKanji, showImage: .constant(false), hideKanji: $hideReadings)
                } else {
                    ProgressView()
                        .onAppear {
                            setCurrentKanji()
                        }
                }
                Spacer()
                
            }
            .padding([.horizontal, .top], Settings.closeButtonPadding)
            .ignoresSafeArea(.container, edges: .top)
            
            // MARK: Нижняя кнопка
            Button(action: {
                if hideReadings {
                    hideReadings = false
                } else {
                    hideReadings = true
                    reloadAction()
                }
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
        .alert("Вы точно хотите удалить этот кандзи из списка?", isPresented: $showDeleteWarning, actions: {
            Button("Нет") {}
            Button("Да") {
                removeKanjiFromList()
            }
        })
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
    
    private func removeKanjiFromList() {
        if var currentKanji = currentKanji {
//            showDeleteWarning = true
            currentKanji.removeFromList()
            store.kanjiKankenStore.update(set: currentKanji)
//            Task {
//                try await Task.sleep(nanoseconds: 100)
                setCurrentKanji()
//                showDeleteWarning = false
//            }
        }
    }
    
    private func reloadAction() {
        currentKanji?.setCurrentDate()
        if let currentKanji = currentKanji {
            store.kanjiKankenStore.update(set: currentKanji)
        }
        setCurrentKanji()
    }
    
    private func setCurrentKanji() {
        currentKanji = getKanji()
//        currentKanji?.setCurrentDate()
        Task {
            print("\nОсталось изучить \(showAfter(min).count) Кандзи")
        }
    }
    
    private func getKanji() -> KanjiKankenModel? {
//        return findExpectedKanjiArray().randomElement()
        let result = Set(showAfter(min)).randomElement()
//        return showAfter(min).randomElement()
        return result
    }
    
    private func findExpectedKanjiArray() -> [KanjiKankenModel] {
        var allCurrentLevelKanji = store.kanjiKankenStore.getAllKanji(below: nouryokuLevel)
        allCurrentLevelKanji = allCurrentLevelKanji
            .filter { !($0.lastAnswer() ?? false) }
            .filter { $0.isInLearningList() ?? false }
        return allCurrentLevelKanji
    }
    
    func showAfter(_ min: Int) -> [KanjiKankenModel] {
        return findExpectedKanjiArray().filter { $0.showKanji(after: min) }
    }
}

#Preview {
    KanjiLearningView(currentKanji: .MOCK_KANJIKANKEN, selectedKanken: false, nouryokuLevel: .N5, kankenLevel: .none)
        .environmentObject(Store())
        .environmentObject(GlobalChanging())
}
