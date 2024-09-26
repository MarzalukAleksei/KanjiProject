//
//  LevelButton.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/08.
//

import SwiftUI

struct LevelButton: View {
    let labelName: Any
    let array: [IAnswers]
    let size: CGSize
    let color: Color
    let colors: [Color] = [ElementsColors.levelButtonWrongAnswer,
                           ElementsColors.levelButtonRightAnswer,
                           ElementsColors.levelButtonUnknownAnswer]
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
                Text("\(inArray())")
                    .font(.system(size: 8))
                    .foregroundColor(.white)
                    .padding(.bottom, 15)
            }
            
            ForEach(0..<3) { index in
                Circle()
                    .trim(from: /*index == 0 ? 0 : */values[0..<index].reduce(0, +),
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
    
    private func getAngles() -> [Double] {
        return progress(array)
    }
    
    private func progress(_ array: [IAnswers]) -> [Double] {
        let inArray = Double(array.count)
        let wrongAnswer = Double(array.filter { $0.showlastAnswer() == false }.count)
        let rightAnswer = Double(array.filter { $0.showlastAnswer() == true }.count)
        let unknownAnswer = Double(array.filter { $0.showlastAnswer() == nil }.count)
        let wrongValue = wrongAnswer / inArray
        let rightValue = rightAnswer / inArray
        let unknownValue = unknownAnswer / inArray
        
        return [wrongValue, rightValue, unknownValue]
    }
    
    private func buttonText() -> String {
        switch labelName {
        case is NouryokuLevel:
            guard let level = labelName as? NouryokuLevel else { return "" }
            return String(level.rawValue)
        case is KankenLevel:
            guard let level = labelName as? KankenLevel else { return "" }
            var text = level.rawValue
            if text.first == "0" {
                text = String(text.dropFirst())
            }
            return text
        case is String:
            return labelName as? String ?? ""
        case _:
            return ""
        }
    }
    
    private func inArray() -> Int {
        return array.count
    }
    
    
}

struct LevelButton_Previews: PreviewProvider {
    static var previews: some View {
        LevelButton(labelName: NouryokuLevel.N5, array: [KanjiModel.MOCK_KANJI, KanjiModel.MOCK_KANJI], size: CGSize(width: 100, height: 100), color: .black)
    }
}
