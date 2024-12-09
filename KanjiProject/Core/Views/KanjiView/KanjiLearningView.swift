//
//  KanjiLearningView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/09/26.
//

import SwiftUI

struct KanjiLearningView: View {
    @EnvironmentObject private var globalChanging: GlobalChanging
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.dismiss) private var dismiss
    @AppStorage("userActivity") private var userActivity: Data?
    @State private var currentKanji: KanjiKankenModel?
    @State private var showWordDetail = false
    @State private var showDeleteWarning = false
    @State private var showListOverWarning = false
    @State private var hideReadings: Bool = true
    @State private var showKeysViewSheet = false
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
                        globalChanging.wordToChange = nil
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
                            Button {
                                showDeleteWarning = true
                            } label: {
                                Text(currentKanji.body)
                                    .modifier(Modifiers.mainKanji)
                            }

                            Spacer()
                            
                            Button {
                                showKeysViewSheet = true
                            } label: {
                                Text(currentKanji.keys)
                                    .modifier(Modifiers.mainKanji)
                            }

                        }
                        
                        KanjiDetailView(currentKanji: currentKanji, showImage: .constant(false), hideKanji: $hideReadings).opacity(!hideReadings ? 1 : 0)
                    } else {
                        ProgressView()
                            .opacity(showListOverWarning ? 0 : 1)
                        // MARK: Выполняется при загрузке экрана, до тех пор, пока currentKanji = nil
                            .task {
                                await allKanji = storeOperations.getKanjiArray(for: nouryokuLevel)
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
                    
                    // MARK: Кнопка правильного ответа
                    Button(action: {
                        rightButtonAction()
                    }, label: {
                        HStack {
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
        .blur(radius: showWordDetail ? Settings.blurEffectValue : 0)

        .alert("Вы точно хотите удалить этот кандзи из списка?", isPresented: $showDeleteWarning, actions: {
            Button("Нет") {}
            Button("Да") {
                removeKanjiFromList()
            }
        })
        .alert("Хотите продолжить изучeние?", isPresented: $showListOverWarning, actions: {
            Button("Повторить все из списка") {
                repeatButton()
            }
            
            Button("Повторить неверные") {
                repeatWrongsButton()
            }
            
            Button("Добавить дополнительные \(DatabaseOptions.maxLearningElementsCount) кандзи") {
                addWordsButton()
            }
            
            Button("Закрыть", role: .cancel) {
                withAnimation(.none) {
                    dismiss()
                }
            }
        }, message: {
//            Text("На сегодня слов больше нет.")
//                .frame(maxWidth: .infinity)
            Text("Как поступим?")
                .frame(maxWidth: .infinity)
        })
        
        .overlay {
            if showWordDetail {
                SelectedWordDetailView(storeOperations: storeOperations)
            }
            
        }
        .onReceive(globalChanging.$wordToChange, perform: { word in
            withAnimation(Settings.animation) {
                if word != nil {
                    showWordDetail = true
                } else {
                    showWordDetail = false
                }
            }
        })
        .sheet(isPresented: $showKeysViewSheet) {
            if let currentKanji = currentKanji {
                ModalKeyDeteilView(currentkanji: currentKanji,
                                storeOperations: storeOperations)
                    .presentationDetents([.medium])
            }
        }
    }
    
    private func setUserActivity() async {
        let activity = UserActivity(data: userActivity)
        activity.newActivity()
        userActivity = activity.encode()
    }
    
    private func repeatWrongsButton() {
        allKanji = storeOperations.getAllWrong(below: nouryokuLevel)
        setCurrentKanji()
    }
    
    private func repeatButton() {
        allKanji = storeOperations.addKanjiWromWithoutDataStamp()
        setCurrentKanji()
    }
    
    private func addWordsButton() {
        allKanji = storeOperations.addNotLearnedKanji(for: nouryokuLevel)
        setCurrentKanji()
    }
    
    private func rightButtonAction() {
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
            currentKanji.removeFromListWithMark()
            storeOperations.updKanji(currentKanji)
            hideReadings = true
            setCurrentKanji()
        }
    }
    
    private func reloadView() {
        setCurrentKanji()
        
        Task(priority: .background) {
            await setUserActivity()
        }
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
    KanjiLearningView(storeOperations: .init(store: Store()), selectedKanken: false, nouryokuLevel: .N5, kankenLevel: .級10)
        .environmentObject(Store())
        .environmentObject(GlobalChanging())
        .environmentObject(UserSettings())
}
