//
//  ActivityModel.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2025/02/02.
//

import Foundation

struct ActivityModel: Codable, IActivity {
    var date: Date?
    var times: Int?
    
    init(data: Data?) {
        do {
            let decode = try decode(data: data)
        } catch {
            print("Activity decode Error")
        }
    }
    
    func newActivity() {
        
    }
    
}
