//
//  SettingView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/12/09.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject private var settings: UserSettings
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBarView(title: "Настройки", corners: .bottomRight, cornerRadius: ElementSize.navigationCornerRadius, heigh: ElementSize.customNavigationBarHeight)
            
            ScrollView {
                VStack(spacing: Settings.paddingBetweenText) {
                    SectionCell(title: "Настройки отображения кандзи")
                    
                    Divider()
                    
                    Cell(title: "Всегда показывать окно выбора",
                         toggle: $settings.showConformationDialog)
                    
                    Divider()
                    
                    Cell(title: "Tолько из выбранного уроня",
                         toggle: $settings.showCurrentLevelOnly)
                    
                    Divider()
                }
            }
            .padding(.vertical, Settings.paddingBetweenElements)
            .padding(.horizontal, Settings.padding)
            
            Spacer()
        }
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

private struct Cell: View {
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
