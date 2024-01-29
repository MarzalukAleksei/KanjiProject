//
//  String + Extensions.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/08/26.
//

import SwiftUI

extension String {
    func textAndLinks() -> [(isText: Bool, text: String)] {
        let text = self.removeBetween("【", and: "】")
        
        var result: [(isText: Bool, text: String)] = []
        let links = links(text: text)
        var newText = text
        
        for index in (0..<links.count).reversed() {
//            newText = newText.replacingCharacters(in: links[index].rightBracket.startIndex...links[index].rightBracket.lastIndex, with: "")
            newText = newText.replacingCharacters(in: links[index].leftBracket.startIndex...links[index].rightBracket.lastIndex, with: "###\(index)")
//            newText = newText.replacingCharacters(in: links[index].leftBracket.startIndex...links[index].leftBracket.lastIndex, with: "")
        }
        var array: [String] = []
        for index in 0..<links.count {
            array = newText.components(separatedBy: "###\(index)")
            
            result.append((isText: true, text: array.removeFirst()))
            newText = array.first ?? ""
            
            let afterIndex = text.index(after: links[index].leftBracket.lastIndex)
            let beforeIndex = text.index(before: links[index].rightBracket.startIndex)
            let middleText = String(text[afterIndex...beforeIndex])
            result.append((isText: false, text: middleText))
            
            if index + 1 == links.count {
                result.append((isText: true, text: array.removeFirst()))
            }
        }
 
        return result
    }
    
    private func links(text: String) -> [(leftBracket: (startIndex: String.Index,
                                                       lastIndex: String.Index),
                                         rightBracket: (startIndex: String.Index,
                                                        lastIndex: String.Index))] {
        
        var result: [(leftBracket: (startIndex: String.Index,
                                    lastIndex: String.Index),
                      rightBracket: (startIndex: String.Index,
                                     lastIndex: String.Index))] = []
        
        var leftBrackes: [(firstIndex: String.Index, lastIndex: String.Index)] = []
        var rightBrackets: [(firstIndex: String.Index, lastIndex: String.Index)] = []
        
        var offSet = 0
        var startIndex: String.Index {
            text.index(text.startIndex, offsetBy: offSet, limitedBy: text.endIndex) ?? text.startIndex
        }
        var lastIndex: String.Index {
            text.index(text.startIndex, offsetBy: offSet + 2, limitedBy: text.endIndex) ?? text.startIndex
        }
        if text.count > 2 {
            
        
        for index in 0..<text.count - 2 {
            offSet = index
            
            if text[startIndex...lastIndex] == "<<<" {
                leftBrackes.append((startIndex, lastIndex))
            }
            
            if text[startIndex...lastIndex] == ">>>" {
                rightBrackets.append((startIndex, lastIndex))
            }
        }
    }
        
        for index in 0..<leftBrackes.count {
            result.append((leftBracket: (startIndex: leftBrackes[index].firstIndex,
                                         lastIndex: leftBrackes[index].lastIndex),
                           rightBracket: (startIndex: rightBrackets[index].firstIndex,
                                          lastIndex: rightBrackets[index].lastIndex)))
        }
//        print(result)
        return result
    }
    
    func removeBetween(_ first: Character, and second: Character) -> String {
        let text = self
        var result = text
        var stack: [Int] = []
        var indexes: [(first: Int, last: Int)] = []
        
        for (index, character) in text.enumerated() {
            if first == character {
                stack.append(index)
            }
            
            if second == character {
                indexes.append((first: stack.removeLast(), last: index))
            }
        }
        
        for index in (0..<indexes.count).reversed() {
            let startIndex = text.index(text.startIndex, offsetBy: indexes[index].first)
            let lastIndex = text.index(text.startIndex, offsetBy: indexes[index].last)
            result = result.replacingCharacters(in: startIndex...lastIndex, with: "")
        }
        
        return result
    }
    
    func removeNumberExampleRow() -> String {
        var result = self
        if result.count > 3 {
            let startIndex = result.startIndex
            var offSet = 2
            var lastIndex: String.Index {
                result.index(startIndex, offsetBy: offSet)
            }
            var sequence: String.SubSequence {
                result[startIndex...lastIndex]
            }
            if sequence.contains(")"), !sequence.contains(":") {
                result = result.replacingOccurrences(of: sequence, with: "")
            } else if sequence.contains(")"), sequence.contains(":") {
                offSet += 1
                result = result.replacingOccurrences(of: sequence, with: "")
            } else if sequence.contains("уст"), result.count < 6 {
                offSet += 1
                result = result.replacingOccurrences(of: sequence, with: "")
            } else if sequence.contains(": ～") {
                offSet -= 1
                result = result.replacingOccurrences(of: sequence, with: "")
            } else if sequence.contains("кн.") {
                offSet += 1
                result = result.replacingOccurrences(of: sequence, with: "кн.")
            }
        }
        
        return result.replaceWords()
    }
    
    private func replaceWords() -> String {
        var result = self
        if result.contains("кн.") {
            result = result.replacingOccurrences(of: "кн.", with: "(Литературное) ")
        } else if result.contains("эпист.") {
            result = result.replacingOccurrences(of: "эпист.", with: "(Толкование)")
//        } else if result.contains("ист.") {
//            result = result.replacingOccurrences(of: "ист.", with: "(Историческое)")
        } else if result.contains("связ.") {
            result = result.replacingOccurrences(of: "связ.", with: "")
        }
        
        return result
    }
}

extension View {
    func navigationBarColor(backgroundColor: UIColor?, tintColor: UIColor?) -> some View {
        self.modifier(NavigationBarColor(backgroundColor: backgroundColor, tintColor: tintColor))
    }
}

extension String {
    func removeAll(after char: Character) -> String {
        guard let endIndex = self.firstIndex(of: char) else {
            return self
        }
        let result = self[self.startIndex..<endIndex]
        return String(result)
    }
}

extension UIWindow {
    static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                if window.isKeyWindow { return window }
            }
        }
        return nil
    }
}

extension UIScreen {
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
}

extension String {
    func between(_ first: Character, and second: Character) -> String {
        guard let firstIndex = self.firstIndex(of: first),
              let secondIndex = self.firstIndex(of: second) else { return "" }
        return String(self[self.index(after: firstIndex)...self.index(before: secondIndex)])
    }
    
    /// Возвращает строку после указанного номера символа
    func after(_ number: Int) -> String {
        if self.count < 1 {
            return self
        }
        let start = self.index(self.startIndex, offsetBy: number)
        let end = self.endIndex
        let result = self[start..<end]
        
        return String(result)
    }
}
