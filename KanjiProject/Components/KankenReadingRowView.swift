//
//  KankenReadingRowView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/01/20.
//

import SwiftUI

struct KankenReadingRowView: View {
    let row: String
    let type: SchoolLevel
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(type.rawValue)
                    .font(.system(size: TextSizes.scloolLevelLabel))
                Text(row)
                    .font(.system(size: TextSizes.kanjiBody))
            }
            Spacer()
        }
        .padding(.horizontal, Settings.padding)
    }
}

#Preview {
    KankenReadingRowView(row: "よ（む）", type: .小)
}
