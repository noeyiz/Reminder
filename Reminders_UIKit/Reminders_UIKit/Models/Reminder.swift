//
//  Reminder.swift
//  Reminders_UIKit
//
//  Created by jiyeon on 11/30/23.
//

import Foundation

struct Reminder {
    var id: UUID = UUID()
    var title: String = ""
    var notes: String?
    var isCompleted: Bool = false
    var priority: Priority = .none
}

extension Reminder {
    
    enum Priority: CaseIterable {
        case none
        case low
        case midium
        case high
        
        func toString() -> String {
            switch (self) {
            case .none: return "None"
            case .low: return "Low"
            case .midium: return "Midium"
            case .high: return "High"
            }
        }
        
        func toMark() -> String {
            switch (self) {
            case .none: return ""
            case .low: return "!"
            case .midium: return "!!"
            case .high: return "!!!"
            }
        }
    }
    
}
