//
//  ModalKeyDeteilView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/11/28.
//

import SwiftUI

struct ModalKeyDeteilView: View {
    @Environment(\.dismiss) private var dismiss
    let currentkanji: KanjiKankenModel
    let storeOperations: StoreOperations
    
    var body: some View {
        VStack  {
            HStack {
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Text("Закрыть")
                        .bold()
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                }
            }
            
            ScrollView {
                let keys = keyButtonAction(currentkanji)
                ForEach(keys) { key in
                    var key = key
                    let showVar = showVariants(&key)
                    Text(attrStr(key, showVar))
                        .modifier(Modifiers.keyModalViewText)
                    
                    Text(key.explanation)
                        .modifier(Modifiers.keyModalViewText)
                    
//                    if key.id != keys.last?.id {
//                        Divider()
//                            .padding(.vertical, Settings.paddingBetweenText)
//                    }
                }
                .padding(.horizontal, Settings.padding)
                .padding(.vertical, Settings.paddingBetweenElements)
            }
            
        }
    }
    private func attrStr(_ key: BushuModel, _ showVar: Bool) -> AttributedString {
        let bodyName = "\(key.body) (\(key.name))"
        let point = showVar ? ", " : "."
        let alsoWrite = showVar ? "так же может иметь написание " : ""
        let variant = showVar ? "\(key.variant)" : ""
        let lastPoint = showVar ? "." : ""
        
        var attributedString = AttributedString("Ключ \(bodyName)\(point)\(alsoWrite)\(variant)\(lastPoint)")
        let nameRange = attributedString.range(of: key.name)
        let bodyRange = attributedString.range(of: key.body)
        let variantRange = attributedString.range(of: variant)
        
        guard let nameRange, let bodyRange else { return attributedString }
        attributedString[bodyRange].foregroundColor = .red
        attributedString[bodyRange].font = .largeTitle
        attributedString[nameRange].foregroundColor = .red
        
        guard let variantRange else { return attributedString }
        attributedString[variantRange].foregroundColor = .red
        
        return attributedString
    }
    
    private func showVariants(_ key: inout BushuModel) -> Bool {
        if key.body == currentkanji.keys, key.variant.isEmpty {
            return false
        } else if key.body != currentkanji.keys, !key.variant.contains(key.body), key.explanation.contains(where: { String($0) == currentkanji.keys }) {
            key.variant += key.variant.isEmpty ? key.body : ", \(key.body)"
        }
        return true
    }
    
    private func keyButtonAction(_ currentKanji: KanjiKankenModel) -> [BushuModel] {
//        if currentKanji.keys == "月" {
//            print("keys")
//        }
        do {
            return try storeOperations.getKeys(for: currentKanji)
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
}
#Preview {
    ModalKeyDeteilView(currentkanji: .ANOTHER_MOCK_KANKENKANJI, storeOperations: StoreOperations(store: Store.MOCK_STORE, chosenLevel: .N5))
}
