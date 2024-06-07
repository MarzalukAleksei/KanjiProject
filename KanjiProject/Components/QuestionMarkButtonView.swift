//
//  QuestionMarkButtonView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/06/02.
//

import SwiftUI

struct QuestionMarkButtonView: View {
    @State var showQuestionMarkMessage = false
    private var massage = ""
    var body: some View {
        Image(systemName: "questionmark.circle")
            .resizable()
            .frame(width: 25, height: 25)
            .foregroundStyle(.secondary)
            .onTapGesture {
                showQuestionMarkMessage = true
            }
            .alert(massage, isPresented: $showQuestionMarkMessage) {
                Button("OK") { }
            }
    }
    
//    func massage(_ massage: String) -> Self {
//        var fnc = self
//        fnc.massage = massage
//        return fnc
//    }
    
    init(_ massage: String = "") {
        self.massage = massage
    }
}

#Preview {
    QuestionMarkButtonView()
}
