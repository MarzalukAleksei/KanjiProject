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
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                CustomNavigationBarView(title: "Kanji")
                ZStack {
                    HStack {
                        Rectangle()
                            .frame(maxWidth: .infinity, maxHeight: 70)
                            .clipShape(PartialRoundedRectangle(cornerRadius: PartsSize.navigationCornerRadius, corners: .topRight))
                            .background(Color.black)
                            .foregroundColor(.white)
                    }
                    Text("Выберите уровень")
                        .font(CustomFont.scroll(size: 20))
                }
                .padding(.bottom, 20)
                
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            //                    TabView {
                            ForEach(Level.allCases.reversed(), id: \.self) { level in
                                LevelButton(levelTitle: level,
                                            size: CGSize(width: PartsSize.levelButtonSize.width,
                                                         height: PartsSize.levelButtonSize.height),
                                            color: selectedLevel == level ? .secondary : .black)
                                .onTapGesture {
                                    withAnimation {
                                        selectedLevel = level
                                    }
                                }
                                
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .onAppear {
                        withAnimation {
                            proxy.scrollTo(selectedLevel, anchor: .center)
                        }
                        
                    }
                }
                List() {
                    ForEach(getKanji(selectedLevel), id: \.self) { element in
                        Text(element.body)
                    }
                }
                .padding(.top, 20)
            }
            Spacer()
        }
    }
    
    func getKanji(_ level: Level) -> [KanjiModel] {
        return Kanji.transformToKanjiModel(kanji: kanji, level)
    }
    
    func setTrims(_ level: Level) -> [Double] {
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
    
    //    func setTrims() -> [Level: [Double]] {
    //        var result: [Level: [Double]] = [:]
    //        var answers: [Double] = []
    //
    //        for level in Level.allCases {
    //            let kanjiArray = Kanji.transformToKanjiModel(kanji: kanji, level)
    //            var rightAnswers = 0
    //            var wrongAnswers = 0
    //
    //            for element in kanjiArray {
    //                if element.rightAnwers > element.wrongAnswers {
    //                    rightAnswers += 1
    //                } else if element.wrongAnswers > element.rightAnwers {
    //                    wrongAnswers += 1
    //                }
    //            }
    //            let notAnswed = kanjiArray.count - rightAnswers - wrongAnswers
    //
    //            answers.append(Double(rightAnswers / kanjiArray.count))
    //            answers.append(Double(wrongAnswers / kanjiArray.count))
    //            answers.append(Double(notAnswed / kanjiArray.count))
    //
    //            result[level] = answers
    //        }
    //
    //        return result
    //    }
}


struct KanjiView_Previews: PreviewProvider {
    static var previews: some View {
        KanjiView()
    }
}
