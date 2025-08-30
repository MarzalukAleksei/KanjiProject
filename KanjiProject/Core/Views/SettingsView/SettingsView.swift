//
//  SettingsView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/12/09.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @AppStorage("User Settings") private var settingsDatabase: Data?
    @State var test: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBarView(title: "Настройки", corners: .bottomRight, cornerRadius: ElementSize.navigationCornerRadius, heigh: ElementSize.customNavigationBarHeight)
            
            ScrollView {
                VStack(spacing: Settings.paddingBetweenText) {
                    SectionCell(title: "Настройки отображения кандзи")
                    
                    CellWithSlider(title: "Отображать значние на английском", toggle: $userSettings.showEnglishMeaning)
                    
                    Divider()
                    
                    CellWithSlider(title: "Всегда показывать окно выбора",
                                   toggle: $userSettings.showKanjiConformationDialog)
                    
                    Divider()
                    
                    CellWithPicker(title: "Сколько кандзи добавлять в окне выбора", basicValue: DatabaseOptions.maxLearningElementsCountBasicValue, selection: $userSettings.newKanjiInConfirmationDialog)
                    
                    Divider()
                    
                    CellWithSlider(title: "Tолько из выбранного уроня",
                                   toggle: $userSettings.showCurrentLevelOnly)
                    
                    Divider()
                    
                    CellWithPicker(title: "Добавлять новых кандзи каждый день", basicValue: DatabaseOptions.newKanjiInDayConstantValue, maxLength: 20 ,selection: $userSettings.newKanjiInDay)
                    
                    Divider()
                    
                    SectionCell(title: "Настройки отображения слов")
                    
                    CellWithSlider(title: "Показывать пояснение на японском",
                                   toggle: $userSettings.showSenceInJapanese)
                    
                    Divider()
                    
                    CellWithSlider(title: "Скрыть фуригану", toggle: $userSettings.hideFurigana)
                    
                    Divider()
                    
                    SectionCell(title: "Общие настройки")
                    
                    CellWithPicker(title: "Добавлять новых слов каждый день", basicValue: DatabaseOptions.newWordsInDayConstantValue, selection: $userSettings.newWordsInDay)
                    
                    Divider()
                    
                }
            }
            .padding(.vertical, Settings.paddingBetweenElements)
            .padding(.horizontal, Settings.padding)
            
            Spacer()
        }
        .onDisappear {
            encodeUserSettings()
        }
    }
    
    func encodeUserSettings() {
        let data = JSONManager.manager.encodeToJSON(userSettings)
        settingsDatabase = data
    }
}

#Preview {
    SettingsView()
        .environmentObject(UserSettings())
}

private struct SectionCell: View {
    let title: String
    
    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, Settings.sectionPadding)
            .opacity(Settings.opacity)
    }
}

private struct CellWithPicker: View {
    let title: String
    let basicValue: Int
    var maxLength = 100
    @Binding var selection: Int
    
    var body: some View {
        HStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Picker("", selection: $selection) {
                ForEach(range(self.basicValue), id: \.self) { num in
                    if num % 5 == 0 {
                        Text("\(num)")
                    }
                }
                .foregroundStyle(.black)
            }
            
        }
    }
    
    private func range(_ baseValue: Int) -> Range<Int> {
        return baseValue..<maxLength + 1
    }
}

private struct CellWithSlider: View {
    let title: String
    @Binding var toggle: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
            CustomSlider(toggle: $toggle, title: ("×", "◯"))
                .modifier(Modifiers.customSlider)
        }
    }
}
