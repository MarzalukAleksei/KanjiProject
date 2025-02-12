//
//  ActivityModel.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2025/02/02.
//

import Foundation

struct ActivityModel: Codable {
    let date: Date
    var actionsCount: Int
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
        if isNewKanji { increaseAdded() }
    }
    
    /// Увеличивает каунтер действий для текущей даты
    mutating func increase() {
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
