//
//  DateStamp.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2025/05/20.
//

import Foundation

struct DateStamp: Codable, Hashable {
    private var dateStamp: Date?
    
    init() {
        dateStamp = Date()
    }
}

extension DateStamp {
    
    func getDate() -> Date? {
        dateStamp
    }
    
    func getDate() -> Date {
        guard let dateStamp else { return Date() }
        return dateStamp
    }
    
    mutating func setCurrentDate() {
        dateStamp = Date()
    }
    
    mutating func resetDate() {
        dateStamp = nil
    }
    
    func minutesPassed() -> Int {
        if let date = getDate() {
            let interval = Int(Date().timeIntervalSince(date)) / 60
            return interval
        }
        return -1
    }
    
    func hoursPassed() -> Int {
        minutesPassed() / 60
    }
    
    func filter(by conditions: Conditions) -> Bool {
        guard let _ = dateStamp else { return true }
        switch conditions {
        case .hours:
            if DatabaseOptions.hoursPassed.first < hoursPassed() {
                return true
            }
        }
        return false
    }
    
    enum Conditions {
        case hours
    }
}
