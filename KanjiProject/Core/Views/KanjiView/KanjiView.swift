//
//  KanjiView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/08.
//

import SwiftUI

struct KanjiView: View {
    @State var selectedLevel: Level = .N5
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                CustomNavigationBarView(title: "Kanji")
                ZStack {
                    HStack {
                        Rectangle()
                            .frame(width: .infinity, height: 70)
                            .clipShape(PartialRoundedRectangle(cornerRadius: PartsSize.navigationCornerRadius, corners: .topRight))
                            .background(Color.black)
                            .foregroundColor(.white)
                    }
                    Text("Выберите уровень")
                        .font(CustomFont.scroll(size: 20))
                }
                .padding(.bottom, 20)
                
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            //                    TabView {
                            ForEach(Level.allCases.reversed(), id: \.self) { level in
                                LevelButton(levelTitle: level,
                                            size: CGSize(width: 100, height: 100),
                                            color: selectedLevel == level ? .secondary : .black)
                                .onTapGesture {
                                    withAnimation {
                                        selectedLevel = level
                                    }
                                }
                                
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .onAppear {
                        withAnimation {
                            proxy.scrollTo(selectedLevel, anchor: .center)
                        }
                        
                    }
                }
                List() {
                    ForEach(getKanji(), id: \.self) { element in
                        Text(element.kun)
                    }
                }
                
            }
            Spacer()
        }
    }
    func getKanji() -> [KanjiModel] {
        
        return []
    }
}


struct KanjiView_Previews: PreviewProvider {
    static var previews: some View {
        KanjiView()
    }
}
