//
//  KankenScrollListView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/11/04.
//

import SwiftUI

struct KankenScrollListView: View {
    @EnvironmentObject private var store: Store
    @AppStorage("selectedRow") var selectedRow: Data?
    @AppStorage("selectedKankenLevel") var selectedKankenLevel: KankenLevel = .級10
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: Settings.paddingBetweenElements) {
                let separate = separate(store.kanjiKanken.get(level: selectedKankenLevel))
                let selectedRow = getSelectedRow()
                ForEach(Array(separate.enumerated()), id: \.element) { (index, array) in
                    NavigationLink(value: KankenFlow(index: index + 1, kanji: array)) {
                        KanjiRow(kanji: array,
                                 number: index + 1,
                                 current: isCurrentRow(selectedRow, index))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, Settings.padding)
        }
        .padding(.top, Settings.paddingBetweenElements)
        .scrollIndicators(.hidden)
    }
    
    // MARK: последняя выбранная ячейка сохраненная в памяти приложения
        func getSelectedRow() -> SelectedKankenRow? {
            guard let data = selectedRow,
                  let result = try? JSONDecoder().decode(SelectedKankenRow.self, from: data) else { return nil }
            return result
        }
        
        func isCurrentRow(_ selectedRow: SelectedKankenRow?, _ index: Int) -> Bool {
            guard let selectedRow = selectedRow else { return false }
            if selectedKankenLevel == selectedRow.level, selectedRow.row == index + 1 {
                return true
            }
            return false
        }
    
    // MARK: Разделение массива на указанное количество элементов
    func separate(_ kankenArray: [KanjiKankenModel]) -> [[KanjiKankenModel]] {
        var result: [[KanjiKankenModel]] = []
        var array: [KanjiKankenModel] = []
        
        for kanji in kankenArray {
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
    KankenScrollListView()
        .environmentObject(Store())
}
