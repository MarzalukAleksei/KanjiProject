//
//  FocusedButtonsActions.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2025/03/09.
//

import SwiftUI

/// Pеализовать использование кнопок Space, Return для какого-либо экшена
/// - parameter combineStates: массив @State переменных, для повторного фокуса.
struct FocusedButtonsActions: View {
    @State private var makeFocused: Bool = true
    
    private var combinedStates: [Bool]
    private var returnButtonAction: () -> Void
    private var spaceButtonAction: () -> Void
    
    init(combinedStates: [Bool], returnButtonAction: @escaping () -> Void, spaceButtonAction: @escaping () -> Void) {
        self.combinedStates = combinedStates
        self.returnButtonAction = returnButtonAction
        self.spaceButtonAction = spaceButtonAction
    }
    
    var body: some View {
        if #available(iOS 17.0, *) {
            FocusedView(makeFocused: $makeFocused) {
                returnButtonAction()
            } spaceButtonAction: {
                spaceButtonAction()
            }
            .onChange(of: combinedStates) { _, _ in
                makeFocused.toggle()
            }
        }
    }
}

/// Позволяет реализовать использование кнопок Space, Return для какого-либо экшена
@available(iOS 17.0, *)
private struct FocusedView: View {
    @Environment(\.scenePhase) private var scenePhase
    @FocusState private var focused: Bool
    @Binding var makeFocused: Bool
    var returnButtonAction: () -> Void
    var spaceButtonAction: () -> Void
    
    var body: some View {
        Color.clear
            .focusable()
            .focused($focused)
            .onKeyPress { keyPress in
                if keyPress.key == .return {
                    returnButtonAction()
                    return .handled
                }
                if keyPress.key == .space {
                    spaceButtonAction()
                    return .handled
                }
                return .ignored
            }
            .onAppear {
                focused = true
            }
            .onChange(of: scenePhase) { _, scenePhase in
                switch scenePhase {
                case .background:
                    focused = false
                case .inactive:
                    focused = false
                case .active:
                    focused = true
                @unknown default:
                    break
                }
            }
            .onChange(of: makeFocused) { _, _ in
                focused = true
            }
    }
}
