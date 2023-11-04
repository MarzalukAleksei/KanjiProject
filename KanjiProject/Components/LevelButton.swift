//
//  LevelButton.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/08.
//

import SwiftUI

struct LevelButton: View {
    @EnvironmentObject var store: Store
    var nouryokuLevelTitle: NouryokuLevel?
    var kankenLevelTitle: KankenLevel?
    var nouryokuKanjiArray: [KanjiModel]?
    var kanjiKankenArray: [KanjiKankenModel]?
    let size: CGSize
    let color: Color
    let colors: [Color] = [.red, .green, .white]
    var values: [Double] {
        if nouryokuKanjiArray != nil {
            return nouryokuProgress()
        } 
        if kanjiKankenArray != nil {
            return kankenProgress()
        }
        return []
    }
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
//                .frame(width: size.width, height: size.height)
            let text = buttonText()
            Text(text)
                .foregroundColor(.white)
                .font(CustomFont.scroll(size: text.count > 1 ? 30 : 35))
            VStack {
                Spacer()
                Text("\(elementCount())")
                    .font(.system(size: 8))
//                    .foregroundColor(.init(red: 139, green: 148, blue: 141))
                    .foregroundColor(.white)
                    .padding(.bottom, 15)
            }
            
            ForEach(0..<3) { index in
                Circle()
                    .trim(from: index == 0 ? 0 : values[0..<index].reduce(0, +),
                          to: values[0...index].reduce(0, +))
                    .stroke(lineWidth: 5)
                    .frame(width: size.width - 20, height: size.height - 20)
                    .foregroundColor(colors[index])
                    .rotationEffect(.degrees(-90))
            }
        }
        .frame(width: size.width, height: size.height)
        .foregroundColor(color)
    }
    
    private func nouryokuProgress() -> [Double] {
        guard let nouryokuKanjiArray = nouryokuKanjiArray else { return [] }
        
        let inArray = Double(nouryokuKanjiArray.count)
        let red = Double(nouryokuKanjiArray.filter { $0.lastAnswerRight == false }.count)
        let green = Double(nouryokuKanjiArray.filter { $0.lastAnswerRight == true }.count)
        let white = Double(nouryokuKanjiArray.filter { $0.lastAnswerRight == nil }.count)
        let redValue = red / inArray
        let greenValue = green / inArray
        let whiteValue = white / inArray
        return [redValue, greenValue, whiteValue]
    }
    
    private func kankenProgress() -> [Double] {
        guard let kanjiKankenArray = kanjiKankenArray else { return [] }
        
        let inArray = Double(kanjiKankenArray.count)
        let red = Double(kanjiKankenArray.filter { $0.lastAnswer == false }.count)
        let green = Double(kanjiKankenArray.filter { $0.lastAnswer == true }.count)
        let white = Double(kanjiKankenArray.filter { $0.lastAnswer == nil }.count)
        let redValue = red / inArray
        let greenValue = green / inArray
        let whiteValue = white / inArray
        return [redValue, greenValue, whiteValue]
    }
    
    private func buttonText() -> String {
        if let nouryokuLevelTitle = nouryokuLevelTitle {
            return String(nouryokuLevelTitle.rawValue)
        }
        if let kankenLevelTitle = kankenLevelTitle {
            var text = kankenLevelTitle.rawValue
            if text.first == "0" {
                text = String(text.dropFirst())
            }
            return text
        }
        return ""
    }
    
    private func elementCount() -> Int {
        if let nouryokuKanjiArray = nouryokuKanjiArray {
            return nouryokuKanjiArray.count
        }
        if let kanjiKankenArray = kanjiKankenArray {
            return kanjiKankenArray.count
        }
        return 0
    }
}

struct LevelButton_Previews: PreviewProvider {
    static var previews: some View {
        LevelButton(nouryokuLevelTitle: .another, nouryokuKanjiArray: [.MOCK_KANJI, .MOCK_KANJI], size: CGSize(width: 100, height: 100), color: .black)
    }
}
