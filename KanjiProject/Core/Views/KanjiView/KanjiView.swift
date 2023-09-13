//
//  KanjiView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/08.
//

import SwiftUI

struct KanjiView: View {
    
    @EnvironmentObject var store: Store
    @State var selectedLevel: Level = .N5
    
    @FetchRequest(entity: Kanji.entity(),
                  sortDescriptors: []) private var kanji: FetchedResults<Kanji>
//    @State var levelsTrim: [Level: [Double]] = [:]
    @State var isPresented = false
    @State private var toggle = false
    @Binding var tabBarIsHidden: Bool
    
    var passingKanji: (index: Int, kanji: [KanjiModel]) = (0, [])
    
    
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
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: Settings.paddingBetweenElements) {
                        let separate = separateKanji(store.kanjiStore.getData(selectedLevel))
                        
                            ForEach(Array(separate.enumerated()), id: \.element) { (index, array) in
                                
                                NavigationLink(value: KanjiFlow(index: index + 1, kanji: array, type: toggle ? "漢" : "問")) {
                                    if !toggle {
                                        KanjiRow(kanji: array, number: index + 1, cellTitle: "問")
                                    } else {
                                        KanjiRow(kanji: array, number: index + 1, cellTitle: "漢")
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
    
    func setTrims(_ level: Level) -> [Double] {
        
        if kanji.isEmpty {
            return [0.0, 0.3, 0.7]
        }
        
        var result: [Double] = []
        let kanjiArray = Kanji.transformToKanjiModel(kanji: kanji, level)
        var answers:(rightAnswers: Int, wrongAnswers: Int) = (0, 0)
        
        for element in kanjiArray {
            if element.rightAnwers > element.wrongAnswers {
                answers.rightAnswers += 1
            } else if element.wrongAnswers > element.rightAnwers {
                answers.wrongAnswers += 1
            }
        }
        result.append(Double(answers.rightAnswers / kanjiArray.count))
        result.append(Double(answers.wrongAnswers / kanjiArray.count))
        result.append(1 - result[0] - result[1])
        
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
