//
//  SettingView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/12/09.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @AppStorage("User Settings") private var settingsDatabase: Data?
    @State var test: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBarView(title: "Настройки", corners: .bottomRight, cornerRadius: ElementSize.navigationCornerRadius, heigh: ElementSize.customNavigationBarHeight)
            
            ScrollView {
                VStack(spacing: Settings.paddingBetweenText) {
                    SectionCell(title: "Настройки отображения кандзи")
                    
                    Divider()
                    
                    CellWithSlider(title: "Всегда показывать окно выбора",
                                   toggle: $userSettings.showConformationDialog)
                    
                    Divider()
                    
                    CellWithSlider(title: "Tолько из выбранного уроня",
                                   toggle: $userSettings.showCurrentLevelOnly)
                    
                    Divider()
                    
                    SectionCell(title: "Общие настройки")
                    
                    CellWithPicker(title: "Добавлять элементов в список", basicValue: DatabaseOptions.maxLearningElementsCountBasicValue, selection: $userSettings.maxLearningElementsCount)
                    
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
    SettingView()
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
        return baseValue..<101
    }
}

private struct CellWithSlider: View {
    let title: String
    @Binding var toggle: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
            CustomSlider(toggle: $toggle)
                .frame(width: ElementSize.customtoggleSize.width,
                       height: ElementSize.customtoggleSize.height)
        }
    }
}
