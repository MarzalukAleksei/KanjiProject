//
//  UserActivity.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/12/05.
//

import Foundation

class UserActivity: IActivity {
    private(set) var kanjiActivity: [ActivityModel] = []
    private(set) var wordsActivity: [ActivityModel] = []
    
    required init(data: Data?) {
        do {
            let decoded = try decode(data: data)
            kanjiActivity = decoded.kanjiActivity
            wordsActivity = decoded.wordsActivity
        } catch {
            print(error)
        }
    }
    
    /// увеличивает added counter
    /// - parameter elements: колличество элементов для изучения. Нужно, если
//    func newKanjiAdded(elements: Int) {
//        guard let last = kanjiActivity.last else {
//            let activity = ActivityModel
//            return
//        }
//    }
    
    func newkanjiActivity(inList count: Int, isNewKanji: Bool) {
        guard var last = kanjiActivity.last else {
            kanjiActivity.append(.init(date: Date(), elementsToLearn: count, isNewKanji: isNewKanji))
            return
        }
        if last.date.isSameDay(with: Date()) {
            last.increase()
            if isNewKanji { last.increaseAdded() }
        } else {
            kanjiActivity.append(.init(date: Date(), elementsToLearn: count, isNewKanji: isNewKanji))
        }
    }
    
//    func newKanjiActivity(inList count: Int) {
//        guard var last = kanjiActivity.last else {
////            activity.append(Date())
//            kanjiActivity.append(.init(date: Date(), elementsInList: count))
//            return
//        }
//        
//        if !isCurrentDateEquel(with: last.date) {
//            kanjiActivity.append(.init(date: Date(), elementsInList: count))
//        } else {
//            last.increase()
////            kanjiActivity[kanjiActivity.count - 1] = last
//            kanjiActivity.updLast(last)
//        }
//    }
}

extension UserActivity {
    
    private func isCurrentDateEquel(with last: Date) -> Bool {
        let currentDateComp = getDateComponents(for: Date())
        let lastDateComp = getDateComponents(for: last)
        
        return currentDateComp == lastDateComp
    }
}
