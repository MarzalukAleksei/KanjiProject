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
                    Text(InterfaceTexts.keyPesentaionStyle(key, showVar))
                        .modifier(Modifiers.keyModalViewText)
                    
                    Text(key.explanation)
                        .modifier(Modifiers.keyModalViewText)
                    
                    if key.id != keys.last?.id {
                        Divider()
                            .padding(.vertical, Settings.paddingBetweenText)
                    }
                }
                .padding(.horizontal, Settings.padding)
                .padding(.vertical, Settings.paddingBetweenElements)
                .scrollIndicators(.hidden)
            }
            
        }
    }
    
    
    private func showVariants(_ key: inout BushuModel) -> Bool {
        if key.body == currentkanji.keys, key.variant.isEmpty {
            return false
        } else if key.body != currentkanji.keys,
                  !key.variant.contains(currentkanji.keys),
                  key.explanation.contains(where: { String($0) == currentkanji.keys }) {
            key.variant += key.variant.isEmpty ? currentkanji.keys : ", \(currentkanji.keys)"
        }
        return true
    }
    
    private func keyButtonAction(_ currentKanji: KanjiKankenModel) -> [BushuModel] {
        
        do {
            let key = try storeOperations.getKeys(for: currentKanji)
            return key
        } catch {
            print(error)
            print(currentKanji.keys)
        }
        return []
    }
}
#Preview {
    ModalKeyDeteilView(currentkanji: .ANOTHER_MOCK_KANKENKANJI, storeOperations: StoreOperations(store: Store.MOCK_STORE, userSettings: UserSettings()))
}
