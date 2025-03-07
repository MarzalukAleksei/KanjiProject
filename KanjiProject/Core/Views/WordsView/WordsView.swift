//
//  WordsView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/02/06.
//

import SwiftUI

struct WordsView: View {
    @EnvironmentObject private var store: Store
    @EnvironmentObject private var tabBar: TabBarState
    @EnvironmentObject private var userSettings: UserSettings
    @AppStorage("baseWordLevel") private var wordLevel: NouryokuLevel = .N5
    @State private var currentLevel: NouryokuLevel = .another
    
    var body: some View {
        NavigationStack {
            VStack {
                CustomNavigationBarView(title: "文字・語彙", corners: [], cornerRadius: ElementSize.navigationCornerRadius, heigh: ElementSize.customNavigationBarHeight)
                
                VStack {
                    BaseWordsSelectLevelView(currentLevel: $currentLevel)
                    Divider()
                    
                    NavigationLink {
                        LearnWordView(storeOperations: StoreOperations(store: store,
                                                                       userSettings: userSettings))
                    } label: {
                        Text("Учить слова")
                            .frame(maxWidth: .infinity)
                            .frame(height: ElementSize.modalViewButtonHeight)
                            .background {
                                Color.black
                            }
                            .clipShape(RoundedRectangle(cornerRadius: Settings.buttonsCornerRadius))
                    }
                    
                    NavigationLink {
                        CheckWordsView(storeOperations: .init(store: store,
                                                              userSettings: userSettings))
                    } label: {
                        Text("ПРОВЕКА СЛОВ")
                            .frame(maxWidth: .infinity)
                            .background {
                                Color.gray
                            }
                    }

                    
                    NavigationLink("To Learn") {
                        if let word = store.baseWordsStore.getAll(for: currentLevel).randomElement() {
                            WordLearningView(level: currentLevel, currentWord: word)
                        } else {
                            EmptyView()
                        }
                    }
                    
                    NavigationLink {
                        SearchWordView()
                    } label: {
                        Text("Find Word")
                    }
                    
//                    NavigationLink {
//                        SetKankenKnajiTranslateView()
//                    } label : {
//                        Text("SET KANKEN KANJI TRANSLATE")
//                    }
//                    .padding(.top, 50)
                }
                .padding(.horizontal, Settings.padding)
                
                Spacer()
                
                Color.gray.ignoresSafeArea()
                    .modifier(Modifiers.tabBarSize)
            }
            .onAppear {
                currentLevel = wordLevel
                tabBar.tabBarIsHidden = false
            }
            .onChange(of: currentLevel) { newValue in
                wordLevel = newValue
            }
        }
    }
}

#Preview {
    WordsView()
        .environmentObject(Store())
        .environmentObject(TabBarState())
        .environmentObject(UserSettings())
}
