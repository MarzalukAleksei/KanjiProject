//
//  KanjiView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/08.
//

import SwiftUI

struct KanjiView: View {
    
    @EnvironmentObject var store: Store
    @AppStorage("selectedLevel") var selectedLevel: NouryokuLevel = .N5
    @AppStorage("selectedRow") var selectedRow: Data?
    
    @FetchRequest(entity: UsersKanji.entity(),
                  sortDescriptors: []) private var kanji: FetchedResults<UsersKanji>
    @State var isPresented = false
    @State private var toggle = false
    @EnvironmentObject var tabBarState: TabBarState
    
    @Environment(\.managedObjectContext) var viewContext
    
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
                        Text("Выберите уровень")
                            .font(CustomFont.scroll(size: 20))
                    }
                    
                    HStack {
                        CustomSlider(toggle: $toggle, title: ("問", "漢"))
                            .frame(width: ElementSize.customtoggleSize.width,
                                   height: ElementSize.customtoggleSize.height)
                        Spacer()
                    }
                    .padding(.leading, Settings.padding)
                    
                }
                .padding(.bottom, 0)
                
// MARK:  Кнопки уровней
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: Settings.paddingBetweenElements) {
                            
                            ForEach(NouryokuLevel.allCases.reversed(), id: \.self) { level in
                                if level != .another {
                                    let kanjiArray = store.kanjiStore.getData(level)
                                    LevelButton(levelTitle: level,
                                                kanjiArray: kanjiArray,
                                                size: CGSize(width: ElementSize.levelButtonSize.width,
                                                             height: ElementSize.levelButtonSize.height),
                                                color: selectedLevel == level ? .secondary : .black)
                                    .onTapGesture {
                                        withAnimation(Settings.animation) {
                                            selectedLevel = level
                                            scrollTo(proxy: proxy)
                                        }
                                }
                                }
                                
                            }
                        }
                        .padding(.horizontal, Settings.padding)
                    }
                    .onAppear {
                        withAnimation(Settings.animation) {
                            scrollTo(proxy: proxy)
                        }
                        
                    }
                }
                .padding(.bottom, Settings.paddingBetweenElements)
                
// MARK: Тестовые данные для кордаты
                Button("Add kanji for test Core Data") {
                    Task {
                        CoreDataManager.shared.add(kanji: store.kanjiStore.getAll().randomElement() ?? .MOCK_KANJI, context: viewContext, kanji)
                    }
                }

// MARK: Список разделенный на ечейки
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: Settings.paddingBetweenElements) {
                        let separate = separateKanji(store.kanjiStore.getData(selectedLevel))
                        let selectedRow = getSelectedRow()
                            ForEach(Array(separate.enumerated()), id: \.element) { (index, array) in
                                
                                NavigationLink(value: KanjiFlow(index: index + 1, kanji: array, type: toggle ? "漢" : "問")) {
                                    if !toggle {
                                        KanjiRow(kanji: array, number: index + 1, cellTitle: "問", current: isCurrentRow(selectedRow, index))
                                    } else {
                                        KanjiRow(kanji: array, number: index + 1, cellTitle: "漢", current: isCurrentRow(selectedRow, index))
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                    }
                    .padding(.top, Settings.paddingBetweenElements)
                    .padding(.horizontal, Settings.padding)
                }
                
            }
            .onAppear {
                tabBarState.tabBarIsHidden = false
            }
// MARK: Destination
            .navigationDestination(for: KanjiFlow.self) { flow in
                if !toggle {
                    LearningView(kanjiFlow: flow)
                } else {
                    
                }
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
        if selectedLevel.rawValue == selectedRow.level, selectedRow.row == index + 1 {
            return true
        }
        return false
    }
//MARK: Разделение массива на указанное количество элементов
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
        proxy.scrollTo(selectedLevel, anchor: .center)
    }
}


struct KanjiView_Previews: PreviewProvider {
    static var previews: some View {
        KanjiView()
            .environmentObject(Store())
            .environmentObject(TabBarState())
    }
}
