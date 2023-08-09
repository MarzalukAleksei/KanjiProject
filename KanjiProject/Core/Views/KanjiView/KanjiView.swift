//
//  KanjiView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/08.
//

import SwiftUI

struct KanjiView: View {
    @State var selectedLevel: Level = .N5
    @FetchRequest(entity: Kanji.entity(),
                  sortDescriptors: []) private var kanji: FetchedResults<Kanji>
    @State var levelsTrim: [Level: [Double]] = [:]
    private var separated: [[KanjiModel]] {
        separateKanji(Kanji.transformToKanjiModel(kanji: kanji, selectedLevel))
    }
    @State var isPresented = false
    @State private var toggle = true
    
    var body: some View {
        NavigationStack() {
            VStack(spacing: 0) {
                CustomNavigationBarView(title: "Изучаем Кандзи", corners: .bottomLeft, heigh: PartsSize.customNavigationBarHeight)
                ZStack {
                    HStack {
                        Rectangle()
                            .frame(maxWidth: .infinity, maxHeight: PartsSize.customtoggleSize.height + (Settings.padding * 2))
                            .clipShape(PartialRoundedRectangle(cornerRadius: PartsSize.navigationCornerRadius, corners: .topRight))
                            .background(Color.black)
                            .foregroundColor(.white)
                    }
                    VStack {
                        Text("Выберите уровень")
                            .font(CustomFont.scroll(size: 20))
                    }
                    
                    HStack {
                        CustomToggleView(toggle: $toggle, title: ("問", "漢"))
                            .frame(width: PartsSize.customtoggleSize.width,
                                   height: PartsSize.customtoggleSize.height)
                        Spacer()
                    }
                    .padding(.leading, 20)
                    
                }
                //                .padding(.bottom, Settings.padding)
                .padding(.bottom, 0)
                
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            
                            ForEach(Level.allCases.reversed(), id: \.self) { level in
                                LevelButton(levelTitle: level,
                                            size: CGSize(width: PartsSize.levelButtonSize.width,
                                                         height: PartsSize.levelButtonSize.height),
                                            color: selectedLevel == level ? .secondary : .black)
                                .onTapGesture {
                                    withAnimation(Animation.easeInOut(duration: 0.5)) {
                                        selectedLevel = level
                                        scrollTo(proxy: proxy)
                                    }
                                }
                                
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .onAppear {
                        withAnimation {
                            scrollTo(proxy: proxy)
                        }
                        
                    }
                }
                
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 10) {
                        if !toggle {
                            ForEach(Array(separateKanji(Kanji.transformToKanjiModel(kanji: kanji, selectedLevel)).enumerated()), id: \.element) { (index, kanjiArray) in
                                
                                NavigationLink(value: kanjiArray) {
                                    KanjiRow(kanji: kanjiArray, number: index + 1)
                                }
                                .buttonStyle(.plain)
                            }
                        } else {
                            ForEach(Array(getKanji(selectedLevel).enumerated()),
                                    id: \.element) { (index, row) in
                                KanjiRow(kanji: [], number: 0)
                            }
                        }
                    }
                    .padding(.top, 10)
                    .padding(.horizontal, 20)
                }
            }
            .navigationDestination(for: ([KanjiModel].self)) { kanji in
                Text("\(kanji.count)")
            }
            
            Spacer()
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
    
    func getKanji(_ level: Level) -> [KanjiModel] {
        let result = Kanji.transformToKanjiModel(kanji: kanji, level)
        print(result.count)
        return result
    }
    
    func setTrims(_ level: Level) -> [Double] {
        
        if kanji.isEmpty {
            return [0.0, 0.0, 1.0]
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
        KanjiView()
    }
}
