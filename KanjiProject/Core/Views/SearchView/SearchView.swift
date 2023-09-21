//
//  SearchView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/09/20.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var store: Store
    @EnvironmentObject private var tabBatState: TabBarState
    @State private var text: String = "青"
    @Binding var isEditing: Bool
    var body: some View {
        NavigationStack {
            VStack {
                SearchNavigationBar(text: $text, isEditing: $isEditing)
                
                ScrollView(showsIndicators: false) {
                    ForEach(findWord(), id: \.self) { word in
                        NavigationLink(value: word) {
                            SearchViewWordRow(word: word)
                                .padding(.top, 1)
                                .multilineTextAlignment(.leading)
                        }
                        .foregroundColor(.black)
                    }
                }
            }
            .navigationDestination(for: DictionaryModel.self) { word in
//                SearchWordDetailView(word: word)
                WordDetailView(word: word)
            }
            .onAppear {
                tabBatState.tabBarIsHidden = false
            }
        }
    }
    func findWord() -> [DictionaryModel] {
        var result: [DictionaryModel] = []
        result = store.dictionaryStore.getAll().filter { $0.body.contains(text) }
        return result
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(isEditing: .constant(false))
            .environmentObject(Store())
    }
}
