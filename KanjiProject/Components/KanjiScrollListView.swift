//
//  KanjiScrollListView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/11/04.
//

import SwiftUI

struct KanjiScrollListView: View {
    @EnvironmentObject private var store: Store
    @AppStorage("selectedNouryokuLevel") var selectedNouryokuLevel: NouryokuLevel = .N5
    @AppStorage("selectedRow") var selectedRow: Data?
//    @AppStorage("testType") var toggle: Bool = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: Settings.paddingBetweenElements) {
                let separate = separateKanji(store.kanjiStore.getData(selectedNouryokuLevel))
                let selectedRow = getSelectedRow()
                    ForEach(Array(separate.enumerated()), id: \.element) { (index, array) in
                        NavigationLink(value: KanjiFlow(index: index + 1, kanji: array, type: "")) {
                            KanjiRow(kanji: array,
                                     number: index + 1,
                                     current: isCurrentRow(selectedRow, index))
                        }
                                
                        .buttonStyle(.plain)
                    }
            }
            .padding(.top, Settings.paddingBetweenElements)
            .padding(.horizontal, Settings.padding)
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
}

#Preview {
    KanjiScrollListView()
        .environmentObject(Store())
}
