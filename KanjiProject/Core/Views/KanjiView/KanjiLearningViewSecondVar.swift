//
//  KanjiLearningViewSecondVar.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/09/26.
//

import SwiftUI

struct KanjiLearningViewSecondVar: View {
    @EnvironmentObject private var globalChanging: GlobalChanging
    @Environment(\.dismiss) private var dismiss
    @State private var currentKanji: KanjiKankenModel?
    @State private var showWordDetail = false
    @State private var showDeleteWarning = false
    @State private var showListOverWarning = false
    @State private var hideReadings: Bool = true
    @State private var allKanji: [KanjiKankenModel] = []
    
    let storeOperations: StoreOperations
    let selectedKanken: Bool
    let nouryokuLevel: NouryokuLevel
    let kankenLevel: KankenLevel
    var body: some View {
        VStack {
            VStack {
                HStack {
                    CloseButton {
                        globalChanging.exampleWord = nil
                        storeOperations.updKanjiKankenFile()
                    }
                    
                    Spacer()
                    
                    Text(!allKanji.isEmpty ? "Осталось изучить \(allKanji.count + 1)" : "Последний")
                        .opacity(currentKanji == nil ? 0 : 1)
                    
                    Spacer()
                }
                
                Group {
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
                        
                        KanjiDetailView(currentKanji: currentKanji, showImage: .constant(false), hideKanji: $hideReadings).opacity(!hideReadings ? 1 : 0)
                    } else {
                        ProgressView()
                            .opacity(showListOverWarning ? 0 : 1)
                        // MARK: Выполняется при загрузке экрана, до тех пор, пока currentKanji = nil
                            .task {
                                await allKanji = storeOperations.getKanjiArray()
                                setCurrentKanji()
                            }
                    }
                    Spacer()
                }
                .overlay {
                    if hideReadings {
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture {
                                hideReadings.toggle()
                            }
                    }
                }
            }
            .padding([.horizontal, .top], Settings.closeButtonPadding)
//            .ignoresSafeArea(.container, edges: .top)
            
            if !hideReadings {
                HStack(spacing: 0) {
                    // MARK: Кнопка неправильного ответа
                    Button {
                        wrongAnswerButtonAction()
                    } label: {
                        HStack {
                            ButtonsImages.xmark
                                .resizable()
                                .frame(width: ElementSize.bottomButtonImage.width,
                                       height: ElementSize.bottomButtonImage.height)
                        }
                        .modifier(Modifiers.wrongAnsweButtonSecondVar)
                    }
                    
                    Rectangle()
                        .frame(width: 1, height: ElementSize.bottomButtonImage.height * 2 + Settings.padding)
                    
                    // MARK: Кнопка обновления
                    Button(action: {
                        reloadButtonAction()
                    }, label: {
                        HStack {
                            //                        ButtonsImages.updateImage
                            ButtonsImages.checkmark
                                .resizable()
                                .frame(width: ElementSize.bottomButtonImage.width,
                                       height: ElementSize.bottomButtonImage.height)
                        }
                        .modifier(Modifiers.learningNextButtonSecondVar)
                    })
                    .font(.title2)
                }
            }
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
            Button("Повторить все") {
                repeatButton()
            }
            
//            Button("Повторить с наихудшими ответами") {
//                
//            }
            
            Button("Добавить дополнительные \(DatabaseOptions.maxLearningElementsCount) кандзи") {
                addWordsButton()
            }
            
            Button("Закрыть", role: .cancel) {
                withAnimation(.none) {
                    dismiss()
                }
            }
        }, message: {
            Text("На сегодня слов больше нет.\nКак поступим?")
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
    
    private func repeatButton() {
        allKanji = storeOperations.addKanjiWromWithoutDataStamp()
        setCurrentKanji()
    }
    
    private func addWordsButton() {
        allKanji = storeOperations.addNotLearnedKanji()
        setCurrentKanji()
    }
    
    private func reloadButtonAction() {
        hideReadings.toggle()
        try? storeOperations.setAnswer(for: currentKanji, answer: .right)
        reloadView()
    }
    
    private func wrongAnswerButtonAction() {
        hideReadings.toggle()
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
    KanjiLearningViewSecondVar(storeOperations: .init(store: Store(), chosenLevel: .another), selectedKanken: false, nouryokuLevel: .N5, kankenLevel: .級10)
        .environmentObject(Store())
        .environmentObject(GlobalChanging())
}
