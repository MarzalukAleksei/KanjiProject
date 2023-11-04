//
//  LevelButton.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/08.
//

import SwiftUI

struct LevelButton: View {
    let level: Any
    let kanjiArray: [Any]
    let size: CGSize
    let color: Color
    let colors: [Color] = [.red, .green, .white]
    var values: [Double] {
        getAngles()
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
            let text = buttonText()
            Text(text)
                .foregroundColor(.white)
                .font(CustomFont.scroll(size: text.count > 1 ? 30 : 35))
            VStack {
                Spacer()
                Text("\(elementCount())")
                    .font(.system(size: 8))
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
        guard let nouryokuKanjiArray = kanjiArray as? [KanjiModel] else { return [] }
        
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
        guard let kanjiKankenArray = kanjiArray as? [KanjiKankenModel] else { return [] }
        
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
        switch level {
        case is NouryokuLevel:
            guard let level = level as? NouryokuLevel else { return "" }
            return String(level.rawValue)
        case is KankenLevel:
            guard let level = level as? KankenLevel else { return "" }
            var text = level.rawValue
            if text.first == "0" {
                text = String(text.dropFirst())
            }
            return text
        case _: break
        }
        return ""
    }
    
    private func elementCount() -> Int {
        return kanjiArray.count
    }
    
    func getAngles() -> [Double] {
        switch kanjiArray {
        case is [KanjiModel]:
            return nouryokuProgress()
        case is [KanjiKankenModel]:
            return kankenProgress()
        case _: break
        }
        return []
    }
}

struct LevelButton_Previews: PreviewProvider {
    static var previews: some View {
        LevelButton(level: NouryokuLevel.N5, kanjiArray: [KanjiModel.MOCK_KANJI, KanjiModel.MOCK_KANJI], size: CGSize(width: 100, height: 100), color: .black)
    }
}
