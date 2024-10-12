//
//  KanjiLearningView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/06/18.
//

import SwiftUI

struct KanjiLearningView: View {
//    @EnvironmentObject private var store: Store
    @EnvironmentObject private var globalChanging: GlobalChanging
    @Environment(\.dismiss) private var dismiss
    @State var currentKanji: KanjiKankenModel?
    @State private var showWordDetail = false
    @State private var showDeleteWarning = false
    @State private var showListOverWarning = false
    @State private var hideReadings: Bool = true
    @State private var allKanji: [KanjiKankenModel] = []
    
    let storeOperations: StoreOperations
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
                        storeOperations.updKanjiKankenFile()
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
                        .opacity(showListOverWarning ? 0 : 1)
                    // MARK: Выполняется при загрузке экрана, до тех пор, пока currentKanji = nil
                        .task {
                            await allKanji = storeOperations.getAllSuitableKanjiArray()
                            setCurrentKanji()
                        }
                }
                Spacer()
                
            }
            .padding([.horizontal, .top], Settings.closeButtonPadding)
            .ignoresSafeArea(.container, edges: .top)
            
            // MARK: Кнопка неправильного ответа
            Button {
                wrongAnswerButtonAction()
            } label: {
                Text("")
                .modifier(Modifiers.wrongAnsweButton)
            }

            // MARK: Кнопка обновления
            Button(action: {
                reloadButtonAction()
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
//        .alert("Хотите продолжить изучание?", isPresented: $showListOverWarning, actions: {
//            Button(action: {
//                dismiss()
//            }, label: {
//                Text("Вернусь позже")
//            })
//            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
//                Text("Продолжить")
//            })
//        })
        .confirmationDialog("Хотите продолжить изучание?", isPresented: $showListOverWarning, actions: {
            Button("Добавить") {
                
            }
            
            Button("Вернусь позже", role: .cancel) {
                withAnimation(.none) {
                    dismiss()
                }
            }
        }, message: {
            Text("Вы хотите добавить дополнительные слова?")
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
    
    private func reloadButtonAction() {
        if hideReadings {
            hideReadings = false
        } else {
            hideReadings = true
            try? storeOperations.setAnswer(for: currentKanji, answer: .right)
            reloadView()
        }
    }
    
    private func wrongAnswerButtonAction() {
        try? storeOperations.setAnswer(for: currentKanji, answer: .wrong)
        reloadView()
    }
    
    // MARK: Убирает кандзи из изучаемого списка
    /// - меняет свойство inList на false
    private func removeKanjiFromList() {
        if var currentKanji = currentKanji {
            //            showDeleteWarning = true
            currentKanji.removeFromList()
            storeOperations.updKanji(currentKanji)
            setCurrentKanji()
        }
    }
    
    private func reloadView() {
        setCurrentKanji()
    }
    
    private func setCurrentKanji() {
        currentKanji = getKanji()
        allKanji.removeAll(where: { $0.id == currentKanji?.id })
        
        if currentKanji != nil {
            print("\nОсталось изучить \(allKanji.count + 1) Кандзи")
        } else {
            print("Все изучено!")
            showListOverWarning = true
        }
    }
    
    private func getKanji() -> KanjiKankenModel? {
        let result = Set(allKanji).randomElement()
        return result
    }
    
}

#Preview {
    KanjiLearningView(currentKanji: .MOCK_KANJIKANKEN, storeOperations: .init(store: Store(), chosenLevel: .N5), selectedKanken: false, nouryokuLevel: .N5, kankenLevel: .none)
        .environmentObject(Store())
        .environmentObject(GlobalChanging())
}
