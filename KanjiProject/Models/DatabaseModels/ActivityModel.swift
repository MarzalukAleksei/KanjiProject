//
//  ActivityModel.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2025/02/02.
//

import Foundation

/// Отображает активность пользователя
/// - parameter date: Время первой активности(отражает день когда была активности)
/// - parameter actionsCount: всего было действий в этот день
/// - parameter added: добавлено новых элементов в этот день
/// - parameter elementsInLearningList: сколько всего было элементов для изучения на момент первой активности в текущий день
struct ActivityModel: Codable {
    let date: Date
    private(set) var actionsCount: Int
    private(set) var added: Int
    let elementsInLearningListInThatDay: Int
    
    init(date: Date, elementsInList: Int) {
        self.date = date
        self.actionsCount = 1
        self.added = 0
        self.elementsInLearningListInThatDay = elementsInList
    }
    
    init(date: Date, elementsToLearn: Int, isNewKanji: Bool) {
        self.date = date
        self.actionsCount = 1
        self.added = 0
        self.elementsInLearningListInThatDay = elementsToLearn
        isNewKanji ? increaseAdded() : ()
        increaseActionsCount()
    }
    
    /// Увеличивает каунтер действий для текущей даты
    mutating func increaseActionsCount() {
        actionsCount += 1
    }
    
    /// Увеличивает added counter
    mutating func increaseAdded() {
        added += 1
    }
    
    /// Нужно ли добавить новый елемент в список
    /// - Parameter max: максимальное число добавляемых элементов
    func addNewElement(max: Int) -> Bool {
        return added < max ? true : false
    }
    
    func opacity() -> Double {
        let res =  Double(actionsCount) / Double(elementsInLearningListInThatDay)
        return res < Settings.minActivityCellOpacity ? Settings.minActivityCellOpacity : res
    }
}

extension Array<ActivityModel> { // Array where Element == ActivityModel
    /// Возвращает массив дат
    func getActivityDates() -> [Date] {
        return map(\.date) // self.map { $0.date }
    }
    
    mutating func updLast(_ last: ActivityModel) {
        self[self.count - 1] = last
    }
}
