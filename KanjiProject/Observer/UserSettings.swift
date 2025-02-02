//
//  UserSettings.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/12/09.
//

import Foundation

class UserSettings: ObservableObject, Codable {
    @Published var showEnglishMeaning = true // not used
    @Published var showKanjiConformationDialog = false // not used
    @Published var showCurrentLevelOnly = false // not used
    @Published var newKanjiInConfirmationDialog = DatabaseOptions.maxLearningElementsCountBasicValue
    @Published var newKanjiInDay = DatabaseOptions.newKanjiInDayConstantValue // not used
    @Published var newWordsInDay = DatabaseOptions.newWordsInDayConstantValue // not used
    
//    @Published var answersInRowFirst = 5
//    @Published var answersInRowSecond = 10
//    @Published var answersInRow = 15
//    @Published var minutesPassedFirst = 60 * 24 // 1 day later
//    @Published var minutesPassedSecond = 60 * 24 * 5 // 5 days later
//    @Published var minutesPassedThird = 60 * 24 * 10 // 10 days later
    
    private var conformationDialogState: Bool {
        get { showKanjiConformationDialog }
        set { showKanjiConformationDialog = newValue }
    }
    
    private var showCurrentLevelOnlyState: Bool {
        get { showCurrentLevelOnly }
        set { showCurrentLevelOnly = newValue }
    }
    
    private var maxLearningElementsCountState: Int {
        get { newKanjiInConfirmationDialog }
        set { newKanjiInConfirmationDialog = newValue }
    }
    
    private var newKanjiInDayState: Int {
        get { newKanjiInDay }
        set { newKanjiInDay = newValue }
    }
    
    private var newWordsInDayState: Int {
        get { newWordsInDay }
        set { newWordsInDay = newValue }
    }
    
    private var showEnglishMeaningState: Bool {
        get { showEnglishMeaning }
        set { showEnglishMeaning = newValue }
    }

    private enum CodingKeys: String, CodingKey {
        case showConformationDialog
        case showCurrentLevelOnly
        case maxLearningElementsCount
        case newWordsInDay
        case newKaniInDay
        case showEnglishMeaning
    }
    
    /// Used for invironment
    init() {}

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        conformationDialogState = try container.decode(Bool.self, forKey: .showConformationDialog)
        showCurrentLevelOnlyState = try container.decode(Bool.self, forKey: .showCurrentLevelOnly)
        maxLearningElementsCountState = try container.decode(Int.self, forKey: .maxLearningElementsCount)
        newWordsInDayState = try container.decode(Int.self, forKey: .newWordsInDay)
        newKanjiInDayState = try container.decode(Int.self, forKey: .newKaniInDay)
        showEnglishMeaningState = try container.decode(Bool.self, forKey: .showEnglishMeaning)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(showKanjiConformationDialog, forKey: .showConformationDialog)
        try container.encode(showCurrentLevelOnly, forKey: .showCurrentLevelOnly)
        try container.encode(newKanjiInConfirmationDialog, forKey: .maxLearningElementsCount)
        try container.encode(newKanjiInDay, forKey: .newKaniInDay)
        try container.encode(newWordsInDay, forKey: .newWordsInDay)
        try container.encode(showEnglishMeaning, forKey: .showEnglishMeaning)
    }
}
