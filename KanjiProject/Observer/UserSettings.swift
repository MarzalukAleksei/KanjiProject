//
//  UserSettings.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/12/09.
//

import Foundation

class UserSettings: ObservableObject, Codable {
    @Published var showConformationDialog = false
    @Published var showCurrentLevelOnly = false
    @Published var maxLearningElementsCount = DatabaseOptions.maxLearningElementsCountBasicValue
    
//    @Published var answersInRowFirst = 5
//    @Published var answersInRowSecond = 10
//    @Published var answersInRow = 15
//    @Published var minutesPassedFirst = 60 * 24 // 1 day later
//    @Published var minutesPassedSecond = 60 * 24 * 5 // 5 days later
//    @Published var minutesPassedThird = 60 * 24 * 10 // 10 days later
    
    private var conformationDialogState: Bool {
        get { showConformationDialog }
        set { showConformationDialog = newValue }
    }
    
    private var showCurrentLevelOnlyState: Bool {
        get { showCurrentLevelOnly }
        set { showCurrentLevelOnly = newValue }
    }
    
    private var maxLearningElementsCountState: Int {
        get { maxLearningElementsCount }
        set {
            maxLearningElementsCount = newValue
        }
    }

    private enum CodingKeys: String, CodingKey {
        case showConformationDialog
        case showCurrentLevelOnly
        case maxLearningElementsCount
    }
    
    init() {}

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        conformationDialogState = try container.decode(Bool.self, forKey: .showConformationDialog)
        showCurrentLevelOnlyState = try container.decode(Bool.self, forKey: .showCurrentLevelOnly)
        maxLearningElementsCountState = try container.decode(Int.self, forKey: .maxLearningElementsCount)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(showConformationDialog, forKey: .showConformationDialog)
        try container.encode(showCurrentLevelOnly, forKey: .showCurrentLevelOnly)
        try container.encode(maxLearningElementsCount, forKey: .maxLearningElementsCount)
    }
}
