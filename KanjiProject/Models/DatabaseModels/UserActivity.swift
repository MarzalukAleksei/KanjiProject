//
//  UserActivity.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/12/05.
//

import Foundation

class UserActivity: IActivity {
    private(set) var activity: [Date]
    private(set) var kanjiActivity: [ActivityModel]?
    private(set) var wordsActivity: [ActivityModel]?
    
    required init(data: Data?) {
        activity = []
        do {
            let decoded = try decode(data: data)
            activity = decoded.activity
        } catch {
            print(error)
        }
    }
    
    func newActivity() {
        guard let lastActivity = activity.last else {
            activity.append(Date())
            return
        }
        let currComp = getDateComponents(for: Date())
        let lastActComp = getDateComponents(for: lastActivity)
        
        if currComp != lastActComp {
            activity.append(Date())
        }
    }
}
