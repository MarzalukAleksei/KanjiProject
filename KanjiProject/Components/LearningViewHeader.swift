//
//  LearningViewHeader.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2025/03/09.
//

import SwiftUI

struct LearningViewHeader: View {
    @EnvironmentObject private var globalChanging: GlobalChanging
    let storeOperations: StoreOperations
    let remain: Int
    let hideRemainText: Bool
    let currentJLPTLevel: NouryokuLevel?
    let hideReading: Bool
    
    var body: some View {
        HStack {
            CloseButton {
                globalChanging.wordToChange = nil
                storeOperations.updKanjiKankenFile()
            }
            
            Spacer()
            
            Text(remain > 0 ? "Осталось изучить \(remain + 1)" : "Последний")
                .opacity(hideRemainText ? 0 : 1)
            
            Spacer()
            
            if let jlpt = currentJLPTLevel {
                Text(jlpt != .another ? "JLPT \(jlpt)" : "")
                    .opacity(hideReading ? 0 : 1)
            }
        }
    }
}


