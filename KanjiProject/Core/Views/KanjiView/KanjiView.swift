//
//  KanjiView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/08.
//

import SwiftUI

struct KanjiView: View {
    
    @EnvironmentObject var store: Store
//    @AppStorage("selectedLevel") var selectedLevel: NouryokuLevel = .N5
    @AppStorage("selectedNouryokuLevel") var selectedNouryokuLevel: NouryokuLevel = .N5
    @AppStorage("selectedKankenLevel") var selectedKankenLevel: KankenLevel = .級10
    @AppStorage("selectedRow") var selectedRow: Data?
    @AppStorage("testType") var toggle: Bool = false
    
    @FetchRequest(entity: UsersKanji.entity(),
                  sortDescriptors: []) private var kanji: FetchedResults<UsersKanji>
    @State var isPresented = false
    @EnvironmentObject var tabBarState: TabBarState
    
    @Environment(\.managedObjectContext) var viewContext
    
//    @State private var selectedType: KanjiTestType = .nouryoku
    
    var body: some View {
        NavigationStack() {
            VStack(spacing: 0) {
                CustomNavigationBarView(title: "漢字を勉強しよう",
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
                Button("Add kanji for test Core Data") {
                    Task {
                        CoreDataManager.shared.add(kanji: store.kanjiStore.getAll().randomElement() ?? .MOCK_KANJI, context: viewContext, kanji)
                    }
                }

// MARK: Список разделенный на ячейки
//                ScrollView(showsIndicators: false) {
//                    LazyVStack(spacing: Settings.paddingBetweenElements) {
//                        let separate = separateKanji(store.kanjiStore.getData(selectedNouryokuLevel))
//                        let selectedRow = getSelectedRow()
//                            ForEach(Array(separate.enumerated()), id: \.element) { (index, array) in
//                                
//                                NavigationLink(value: KanjiFlow(index: index + 1, kanji: array, type: toggle ? "漢" : "問")) {
//                                    if !toggle {
//                                        KanjiRow(kanji: array, number: index + 1, current: isCurrentRow(selectedRow, index))
//                                    } else {
//                                        KanjiRow(kanji: array, number: index + 1, current: isCurrentRow(selectedRow, index))
//                                    }
//                                }
//                                .buttonStyle(.plain)
//                            }
//                    }
//                    .padding(.top, Settings.paddingBetweenElements)
//                    .padding(.horizontal, Settings.padding)
//                }
                if toggle {
                    KankenScrollListView()
                } else {
                    KanjiScrollListView()
                }
            }
            .onAppear {
                tabBarState.tabBarIsHidden = false
            }
// MARK: Destinations
            .navigationDestination(for: KanjiFlow.self) { flow in
                LearningView(kanjiFlow: flow)
            }
            .navigationDestination(for: KankenFlow.self) { flow in
                
            }
            
            Spacer()
            
            Color.gray.ignoresSafeArea()
                .modifier(Modifiers.tabBarSize)
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
    
    func scrollTo(proxy: ScrollViewProxy) {
        proxy.scrollTo(selectedNouryokuLevel, anchor: .center)
    }
}


struct KanjiView_Previews: PreviewProvider {
    static var previews: some View {
        KanjiView()
            .environmentObject(Store())
            .environmentObject(TabBarState())
    }
}
