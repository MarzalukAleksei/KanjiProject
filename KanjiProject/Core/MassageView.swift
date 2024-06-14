//
//  MassageView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/06/07.
//

import SwiftUI

struct MassageView: View {
    let massage: String
    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()
            VStack{
                WithTextRect(text: massage)
            }
            
        }
        .padding(.bottom, 100)
    }
}

private struct WithTextRect: View {
    @Environment(\.dismiss) var dismiss
    let text: String
    var body: some View {
        VStack {
            Text(text)
                .background(Color.white)
                .padding(10)
                .border(Color.white, width: 10)
                .padding([.top], 100)
                .padding([.horizontal], 50)
            Button(action: {
                dismiss()
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 0.1)
                        .foregroundStyle(.black)
                        .shadow(radius: 10)
                    Text("Закрыть")
                        .foregroundStyle(.black)
                }
                
            })
            .frame(maxWidth: .infinity, maxHeight: 30)
            .padding(.horizontal, 50 + 10)
        }
    }
}

#Preview {
    MassageView(massage: KankenLevel.whatIsIt())
}
