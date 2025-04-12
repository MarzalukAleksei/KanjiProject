//
//  UserSettings.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/12/09.
//

import Foundation

/// Контейнер, хранящий переменные, значения которых меняет пользователь в зависимости от собственных потребностей
final class UserSettings: ObservableObject, Codable {
    /// Показать перевод на английский
    @Published var showEnglishMeaning = true
    
    /// Показывать окно выбора режива при каждом переходе на экран изучения кандзи
    @Published var showKanjiConformationDialog = false // not used
    
    /// При выборе уровня, отображать только выбранный уровень если true, при false отображать текущий и ниже
    @Published var showCurrentLevelOnly = false // not used
    
    /// Сколько новых кандзи добавлять при выборе соответстующей строки в окне
    @Published var newKanjiInConfirmationDialog = DatabaseOptions.maxLearningElementsCountBasicValue
    
    /// Сколько новых кандзи добавлять кажрый день новой активности
    @Published var newKanjiInDay = DatabaseOptions.newKanjiInDayConstantValue // not used
    
    /// Сколько новых слов добавлять кажрый день новой активности
    @Published var newWordsInDay = DatabaseOptions.newWordsInDayConstantValue // not used
    
    /// Для отображения значения на японском.
    @Published var showSenceInJapanese = false // not used
    
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
    
    private var showSenceInJapaneseState: Bool {
        get { showSenceInJapanese }
        set { showSenceInJapanese = newValue }
    }

    private enum CodingKeys: String, CodingKey {
        case showConformationDialog
        case showCurrentLevelOnly
        case maxLearningElementsCount
        case newWordsInDay
        case newKaniInDay
        case showEnglishMeaning
        case showSenceInJapanese
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
        showSenceInJapaneseState = try container.decode(Bool.self, forKey: .showSenceInJapanese)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(showKanjiConformationDialog, forKey: .showConformationDialog)
        try container.encode(showCurrentLevelOnly, forKey: .showCurrentLevelOnly)
        try container.encode(newKanjiInConfirmationDialog, forKey: .maxLearningElementsCount)
        try container.encode(newKanjiInDay, forKey: .newKaniInDay)
        try container.encode(newWordsInDay, forKey: .newWordsInDay)
        try container.encode(showEnglishMeaning, forKey: .showEnglishMeaning)
        try container.encode(showSenceInJapanese, forKey: .showSenceInJapanese)
    }
}
