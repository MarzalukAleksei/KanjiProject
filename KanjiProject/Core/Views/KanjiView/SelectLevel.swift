//
//  SelectLevel.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/06/24.
//

import SwiftUI

struct SelectLevel: View {
//    @EnvironmentObject var stores: Stores
    @FetchRequest(entity: Kanji.entity(),
                  sortDescriptors: []) var kanji: FetchedResults<Kanji>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(Level.allCases, id: \.self) { level in
                    NavigationLink("\(level.rawValue)", value: level)
                    
                }
            }
            .navigationDestination(for: Level.self) { level in
                let array = data(level: level)
                LearningCardView(currentLearning: array, curentKanji: array.first ?? .MOCK_KANJI)
            }
        }
    }
    
    func data(level: Level) -> [KanjiModel] {
        var result = Kanji.transformToKanjiModel(kanji: kanji, level)
        
        return result
    }
}

struct SelectLevel_Previews: PreviewProvider {
    static var previews: some View {
        SelectLevel()
//            .environmentObject(Stores())
    }
}
