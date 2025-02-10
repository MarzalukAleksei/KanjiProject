//
//  IActivity.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/12/06.
//

import Foundation

protocol IActivity: Codable {
    init(data: Data?)
    
}

extension IActivity {
    func getDateComponents(for date: Date) -> DateComponents {
        return date.getDateComponents()
    }
    
    static func getDateComponents(for date: Date) -> DateComponents {
        return date.getDateComponents()
    }
    
    func encode() -> Data {
        let data = JSONManager.manager.encodeToJSON(self)
        return data
    }
    
    func decode(data: Data?) throws -> Self {
        guard let data = data,
              let userActivity: Self = JSONManager.manager.decodeToModel(data) else { throw MyErrors.activityDecodeFaled }
        return userActivity
    }
}
