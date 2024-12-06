//
//  UserActivity.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/12/05.
//

import Foundation

class UserActivity: Codable {
    private(set) var activity: [Date]
    
    init(data: Data?) {
        activity = []
        activity = decode(data: data)
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
    
    func encode() -> Data {
        let data = JSONManager.manager.encodeToJSON(self)
        return data
    }
}

extension UserActivity {
    private func getDateComponents(for date: Date) -> DateComponents {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: date)
        return components
    }
    
    private func decode(data: Data?) -> [Date] {
        guard let data = data,
              let userActivity: UserActivity = JSONManager.manager.decodeToModel(data) else { return [] }
        return userActivity.activity
    }
}
