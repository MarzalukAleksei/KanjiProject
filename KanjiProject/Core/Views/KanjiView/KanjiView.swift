//
//  KanjiView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/08.
//

import SwiftUI

struct KanjiView: View {
    
    @EnvironmentObject var store: Store
    @EnvironmentObject var tabBarState: TabBarState
//    @AppStorage("selectedLevel") var selectedLevel: NouryokuLevel = .N5
    @AppStorage("selectedNouryokuLevel") var selectedNouryokuLevel: NouryokuLevel = .N5
    @AppStorage("selectedKankenLevel") var selectedKankenLevel: KankenLevel = .級10
    @AppStorage("selectedRow") var selectedRow: Data?
    @AppStorage("kanjiTypeSlider") var toggleInStorage: Bool = false
    @State var toggle = false // true - Kanken, false - JLPT
    @State private var showLearningView = false
    @State private var showLearningByKanjiSecondVar = false
    @State private var showCheckView = false
    @State private var showLearningByWord = false
    @State private var reloadView = true
    
    @FetchRequest(entity: UsersKanji.entity(),
                  sortDescriptors: []) private var kanji: FetchedResults<UsersKanji>
    @State var isPresented = false
    
    @Environment(\.managedObjectContext) var viewContext
    @StateObject private var kanjiKankenStore = KanjiKankenStore() // Только для обновления вью
    
//    @State private var selectedType: KanjiTestType = .nouryoku
    
    var body: some View {
        NavigationStack() {
            VStack(spacing: 0) {
                CustomNavigationBarView(title: Texts.kanjiViewTitle,
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
                        Text(toggle ? "KANKEN 漢検": "JLPT 日本語能力試験" )
                            .font(CustomFont.scroll(size: 20))
                    }
// MARK: Custom Toggle
                    HStack {
                        CustomSlider(toggle: $toggle, title: ("", ""))
                            .frame(width: ElementSize.customtoggleSize.width,
                                   height: ElementSize.customtoggleSize.height)
                        Spacer()
                    }
                    .padding(.leading, Settings.padding)
                }
                .padding(.bottom, 0)
// MARK:  Кнопки уровней
                LevelSelectorView(toggle: $toggle)
                .padding(.bottom, Settings.paddingBetweenElements)
                
// MARK: Тестовые данные для кордаты
//                Button("Add kanji for test Core Data") {
//                    Task {
//                        CoreDataManager.shared.add(kanji: store.kanjiStore.getAll().randomElement() ?? .MOCK_KANJI, context: viewContext, kanji)
//                    }
//                }
                
// MARK: Кнопки повторения и изучения
                LearningOrRememberSelectButtonsView(showLearningView: $showLearningView, showLearningByKanjiSecondVar: $showLearningByKanjiSecondVar, showCheckView: $showCheckView, showLearnigByWord: $showLearningByWord)
                
// MARK: Список разделенный на ячейки
                GeometryReader { geo in
                    ZStack {
                        KankenScrollListView()
                            .offset(x: toggle ? 0 : geo.size.width)
                            .opacity(toggle ? 1 : 0)
                        KanjiScrollListView()
                            .offset(x: toggle ? -geo.size.width : 0)
                            .opacity(toggle ? 0 : 1)
                        
                    }
                }
            }
            .onAppear {
                tabBarState.tabBarIsHidden = false
                toggle = toggleInStorage
            }
            .onChange(of: toggle) { value in
                toggleInStorage = value
            }
            
// MARK: Destinations
            .navigationDestination(for: KanjiFlow.self) { flow in
                NouryokuKanjiLearningView(kanjiFlow: flow)
            }
            .navigationDestination(for: KankenFlow.self) { flow in
                KankenKanjiLearningView(kankenFlow: flow)
            }
            
            Spacer()
            
            Color.gray.ignoresSafeArea()
                .modifier(Modifiers.tabBarSize)
        }
        .fullScreenCover(isPresented: $showCheckView) {
            KanjiCheckView(selectedKanken: toggle, nouryokuLevel: selectedNouryokuLevel, kankenLevel: selectedKankenLevel)
                .onDisappear {
                    let kanjiStore = store.kanjiKankenStore.getAll()
//                    self.kanjiKankenStore.clearAll()
                    self.kanjiKankenStore.updateAll(data: kanjiStore)
                }
        }
//        .fullScreenCover(isPresented: $showLearningView) {
//            KanjiLearningView(storeOperations: .init(store: store, chosenLevel: selectedNouryokuLevel), selectedKanken: toggle, nouryokuLevel: selectedNouryokuLevel, kankenLevel: selectedKankenLevel)
//            //                .onDisappear {
//            //
//            //                }
//        }
        .fullScreenCover(isPresented: $showLearningByKanjiSecondVar) {
            KanjiLearningViewSecondVar(storeOperations: .init(store: store, chosenLevel: selectedNouryokuLevel), selectedKanken: toggle, nouryokuLevel: selectedNouryokuLevel, kankenLevel: selectedKankenLevel)
        }
        .fullScreenCover(isPresented: $showLearningByWord) {
            LearningByWordView(nouryokuLevel: selectedNouryokuLevel, databaseOperation: .init(store: store, chosenLevel: selectedNouryokuLevel))
                .onDisappear {
                    let kanjiStore = store.kanjiKankenStore.getAll()
//                    self.kanjiKankenStore.clearAll()
                    self.kanjiKankenStore.updateAll(data: kanjiStore)
                }
        }

    }
    
// MARK: последняя выбранная ячейка сохраненная в памяти приложения
    func getSelectedRow() -> SelectedKanjiRow? {
        guard let data = selectedRow,
              let result = try? JSONDecoder().decode(SelectedKanjiRow.self, from: data) else { return nil }
        return result
    }
    
    func isCurrentRow(_ selectedRow: SelectedKanjiRow?, _ index: Int) -> Bool {
        guard let selectedRow = selectedRow else { return false }
        if selectedNouryokuLevel.rawValue == selectedRow.level, selectedRow.row == index + 1 {
            return true
        }
        return false
    }
    
// MARK: Разделение массива на указанное количество элементов
    func separateKanji(_ kanjiArray: [KanjiModel]) -> [[KanjiModel]] {
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
    }
}
