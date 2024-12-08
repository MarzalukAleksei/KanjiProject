//
//  SchoolLevelModel.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/01/24.
//

import Foundation

enum SchoolLevel: String, Codable, CaseIterable {
    case 小 = "［小］"
    case 中 = "［中］"
    case 高 = "［高］"
    case 外 = "［外］"
}

extension SchoolLevel {
    func explanation() -> String {
        switch self {
        case .小:
            "Представляет собой уровень, который японцы изучают в начальной школе"
        case .中:
            "Представляет собой уровень, который японцы изучают в средней школе"
        case .高:
            "Представляет собой уровень, который японцы изучают в старшей школе"
        case .外:
            "Представляет собой уровень, который не входит в школьную программу, изучается для специализированного обучения, а так же содержит исключения из правил"
        }
    }
}
