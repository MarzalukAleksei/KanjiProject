//
//  LearningView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/10.
//

import SwiftUI

struct LearningView: View {
    
    @Binding var tabBarIsHidden: Bool
    var kanjiFlow: KanjiFlow
    @State private var currentKanjiIndex = 0
    @State var index = 0
//    let dictionary: [DictionaryModel]
//    @FetchRequest(entity: DictionaryCoreData.entity(),
//                  sortDescriptors: [NSSortDescriptor(key: "body", ascending: true)]) var dictionary: FetchedResults<DictionaryCoreData>
    
    var body: some View {
        VStack {
            
            ZStack {
                CustomNavigationBarView(corners: [.bottomLeft, .bottomRight],
                                        cornerRadius: Settings.learningViewCornerRadius,
                                        heigh: PartsSize.learningViewNavigationBarHeght)
                
                LearningFrontSideView(index: kanjiFlow.index,
                                      kanji: kanjiFlow.kanji[currentKanjiIndex],
                                      number: currentKanjiIndex + 1,
                                      count: kanjiFlow.kanji.count)
                    
            }
            .frame(maxHeight: PartsSize.learningViewNavigationBarHeght)
            .onTapGesture {
                withAnimation(Settings.animation) {
                    addIndex()
                }
//                reduceIndex()
            }
            
            ScrollView {
                LazyVStack(spacing: Settings.paddingBetweenElements + 1){
                    LearningCell(title: "訓読み:", kanji: kanjiFlow.kanji[currentKanjiIndex], type: .kun)
                        .modifier(Modifiers.learningCell)
                        .padding(1)
                    
                    LearningCell(title: "音読み:", kanji: kanjiFlow.kanji[currentKanjiIndex], type: .on)
                        .modifier(Modifiers.learningCell)
                        .padding(1)
                    
                    LearningCell(title: "Значение:", kanji: kanjiFlow.kanji[currentKanjiIndex], type: .translate)
                        .modifier(Modifiers.learningCell)
                        .padding(1)
                    
                    HStack {
                        Text("Примеры:")
                            .opacity(Settings.opacity)
                        Spacer()
                    }
                    
                    ForEach(examples(), id: \.self) { exp in
                        LearningCell(title: "Примеры:", type: .examples, dictionary: exp)
                            .modifier(Modifiers.learningCell)
                            .padding(1)
                    }
                }
            }
            .padding(.horizontal ,Settings.padding - 1)
            .padding(.top, Settings.paddingBetweenElements)
            
            Spacer()
            
            DismissButton()

        }
        .onAppear {
            tabBarIsHidden = true
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func addIndex() {
        if currentKanjiIndex < kanjiFlow.kanji.count - 1 {
            currentKanjiIndex += 1
        }
    }
    
    func reduceIndex() {
        if currentKanjiIndex > 0 {
            currentKanjiIndex -= 1
        }
    }
    
    func examples() -> [DictionaryModel] {
        let kanji = kanjiFlow.kanji[currentKanjiIndex]
        let result = DictionaryModel.dictionary.filter {
            $0.body.contains(kanji.body)
        }.sorted {
            $0.body.count < $1.body.count
//            $0.body < $1.body
        }
        
        return result
    }
}

struct LearningView_Previews: PreviewProvider {
    static var previews: some View {
        LearningView(tabBarIsHidden: .constant(false), kanjiFlow: .MOCK_KANJIFLOW)
    }
}
