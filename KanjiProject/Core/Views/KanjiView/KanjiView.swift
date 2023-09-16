//
//  KanjiView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/08.
//

import SwiftUI

struct KanjiView: View {
    
    @EnvironmentObject var store: Store
    @AppStorage("selectedLevel") var selectedLevel: Level = .N5
    @AppStorage("selectedRow") var selectedRow: Data?
    
    @FetchRequest(entity: UsersKanji.entity(),
                  sortDescriptors: []) private var kanji: FetchedResults<UsersKanji>
    @State var isPresented = false
    @State private var toggle = false
    @Binding var tabBarIsHidden: Bool
    
    @Environment(\.managedObjectContext) var viewContext
    
    var body: some View {
        NavigationStack() {
            VStack(spacing: 0) {
                CustomNavigationBarView(title: "漢字を勉強しよう",
                                        corners: .bottomLeft,
                                        cornerRadius: PartsSize.navigationCornerRadius,
                                        heigh: PartsSize.customNavigationBarHeight)
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
                            .frame(width: PartsSize.customtoggleSize.width,
                                   height: PartsSize.customtoggleSize.height)
                        Spacer()
                    }
                    .padding(.leading, Settings.padding)
                    
                }
                //                .padding(.bottom, Settings.padding)
                .padding(.bottom, 0)
                
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: Settings.paddingBetweenElements) {
                            
                            ForEach(Level.allCases.reversed(), id: \.self) { level in
                                let kanjiArray = store.kanjiStore.getData(level)
                                LevelButton(levelTitle: level,
                                            kanjiArray: kanjiArray,
                                            size: CGSize(width: PartsSize.levelButtonSize.width,
                                                         height: PartsSize.levelButtonSize.height),
                                            color: selectedLevel == level ? .secondary : .black)
                                .onTapGesture {
                                    withAnimation(Settings.animation) {
                                        selectedLevel = level
                                        scrollTo(proxy: proxy)
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
                
                Button("TEST SAVE") {
                    CoreDataManager.shared.add(kanji: store.kanjiStore.getAll().randomElement()!, context: viewContext)
                }
                
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
//                    .padding(.bottom, Settings.paddingBetweenElements)
                }
                
            }
            .onAppear {
                tabBarIsHidden = false
            }
            .navigationDestination(for: KanjiFlow.self) { flow in
                if !toggle {
                    LearningView(tabBarIsHidden: $tabBarIsHidden, kanjiFlow: flow)
                } else {
                    
                }
            }
            
            Spacer()
            
            Color.gray.ignoresSafeArea()
                .modifier(Modifiers.tabBarSize)
        }
        //        .sheet(isPresented: $isPresented) {
        //            Text("sdsbdv")
        //        }
    }
    
    // строка была выбрана ранее
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
        KanjiView(tabBarIsHidden: .constant(false))
            .environmentObject(Store())
    }
}
