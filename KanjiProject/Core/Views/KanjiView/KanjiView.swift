//
//  KanjiView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/08.
//

import SwiftUI

struct KanjiView: View {
    @EnvironmentObject private var store: Store
    @EnvironmentObject private var tabBarState: TabBarState
    @EnvironmentObject private var userSettings: UserSettings
//    @AppStorage("selectedLevel") var selectedLevel: NouryokuLevel = .N5
    @AppStorage("selectedNouryokuLevel") private var selectedNouryokuLevel: NouryokuLevel = .N5
    @AppStorage("selectedKankenLevel") private var selectedKankenLevel: KankenLevel = .級10
    @AppStorage("selectedRow") private var selectedRow: Data?
    @AppStorage("kanjiTypeSlider") private var toggleInStorage: Bool = false
    @AppStorage("userActivity") private var userActivity: Data?
    @State private var toggle = false // true - Kanken, false - JLPT
    @State private var showLearningView = false
    @State private var reloadView = true
    @State private var showInfoAlert = false
    
    @FetchRequest(entity: UsersKanji.entity(),
                  sortDescriptors: []) private var kanji: FetchedResults<UsersKanji>
    @State private var isPresented = false
    
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var kanjiKankenStore = KanjiKankenStore() // Только для обновления вью
    
//    @State private var selectedType: KanjiTestType = .nouryoku
    
    var body: some View {
//        NavigationStack() {
            VStack(spacing: 0) {
                CustomNavigationBarView(title: InterfaceTexts.kanjiViewTitle,
                                        corners: .bottomLeft,
                                        cornerRadius: ElementSize.navigationCornerRadius,
                                        heigh: ElementSize.customNavigationBarHeight)
//MARK: Область между хедером и кнопками уровня
                ZStack {
                    HStack {
                        Rectangle()
                            .modifier(Modifiers.roundedRectTopRightBlackPart)
                    }
                    VStack {
                        Text(toggle ? InterfaceTexts.kanjiKanken: InterfaceTexts.kanjiNouryoku )
                            .font(CustomFont.scroll(size: 20))
                    }
// MARK: Custom Toggle
                    HStack {
                        CustomSlider(toggle: $toggle)
                            .modifier(Modifiers.customSlider)
                        Spacer()
                    }
                    .padding(.leading, Settings.padding)
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            showInfoAlert = true
                        } label: {
                            ButtonsImages.questionImage
                                .resizable()
                                .frame(width: ElementSize.questionMarkSize.width,
                                       height: ElementSize.questionMarkSize.height)
                                .foregroundStyle(Color.black)
                        }

                    }
                    .padding(.trailing, Settings.padding * 2.5)
                    .opacity(Settings.questionMarkButtonOpacity)
                }
                .padding(.bottom, 0)
// MARK:  Кнопки уровней
                LevelSelectorView(toggle: $toggle)
                .padding(.bottom, Settings.paddingBetweenElements)
                .onAppear {
                    reloadView.toggle()
                }
                
// MARK: Тестовые данные для кордаты
//                Button("Add kanji for test Core Data") {
//                    Task {
//                        CoreDataManager.shared.add(kanji: store.kanjiStore.getAll().randomElement() ?? .MOCK_KANJI, context: viewContext, kanji)
//                    }
//                }
                
// MARK: Кнопки повторения и изучения
                LearningOrRememberSelectButtonsView(showLearningView: $showLearningView)
                
// MARK: Список разделенный на ячейки
//                GeometryReader { geo in
//                    ZStack {
//                        KankenScrollListView()
//                            .offset(x: toggle ? 0 : geo.size.width)
//                            .opacity(toggle ? 1 : 0)
//                        KanjiScrollListView()
//                            .offset(x: toggle ? -geo.size.width : 0)
//                            .opacity(toggle ? 0 : 1)
//                        
//                    }
//                }
                
// MARK: Активность пользователя
                Text("Ваша активность")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.vertical, Settings.paddingBetweenText)
                    .padding(.horizontal, Settings.padding)
//                GeometryReader { geo in
                UserActivityView(userActivity: UserActivity(data: userActivity).kanjiActivity)
                        .padding(.horizontal, Settings.padding)
//                }
                
            }
            .onAppear {
                tabBarState.tabBarIsHidden = false
                toggle = toggleInStorage
            }
            .onChange(of: toggle) { value in
                toggleInStorage = value
            }
            .fullScreenCover(isPresented: $showLearningView) {
                KanjiLearningView(storeOperations: .init(store: store, userSettings: userSettings), selectedKanken: toggle, nouryokuLevel: selectedNouryokuLevel, kankenLevel: selectedKankenLevel)
                
            }
            .alert(allertTitle(), isPresented: $showInfoAlert) {
                Button(InterfaceTexts.infoAlertButtonOnMainview) {}
            }
            
            Spacer()
            
            Color.gray.ignoresSafeArea()
                .modifier(Modifiers.tabBarSize)
//        }
        

    }
    
// MARK: последняя выбранная ячейка сохраненная в памяти приложения
    private func getSelectedRow() -> SelectedKanjiRow? {
        guard let data = selectedRow,
              let result = try? JSONDecoder().decode(SelectedKanjiRow.self, from: data) else { return nil }
        return result
    }
    
    private func allertTitle() -> String {
        switch toggleInStorage {
        case true:
            return InterfaceTexts.infoAlertOnMainViewKanken(store.kanjiKankenStore.getAll().count)
        case false:
            return InterfaceTexts.infoAlertOnMainViewJLPT(store.kanjiKankenStore.getAllKanji(below: .N1).count)
        }
    }
    
    private func isCurrentRow(_ selectedRow: SelectedKanjiRow?, _ index: Int) -> Bool {
        guard let selectedRow = selectedRow else { return false }
        if selectedNouryokuLevel.rawValue == selectedRow.level, selectedRow.row == index + 1 {
            return true
        }
        return false
    }
    
// MARK: Разделение массива на указанное количество элементов
    private func separateKanji(_ kanjiArray: [KanjiModel]) -> [[KanjiModel]] {
        var result: [[KanjiModel]] = []
        var array: [KanjiModel] = []
        
        for kanji in kanjiArray {
            if array.count < Settings.elementsInRow {
                array.append(kanji)
            } else {
                result.append(array)
                array.removeAll()
                array.append(kanji)
            }
        }
        
        if !array.isEmpty {
            result.append(array)
        }
        
        return result
    }
    
//    func scrollTo(proxy: ScrollViewProxy) {
//        proxy.scrollTo(selectedNouryokuLevel, anchor: .center)
//    }
}


struct KanjiView_Previews: PreviewProvider {
    static var previews: some View {
        KanjiView()
            .environmentObject(Store())
            .environmentObject(TabBarState())
            .environmentObject(UserSettings())
    }
}
