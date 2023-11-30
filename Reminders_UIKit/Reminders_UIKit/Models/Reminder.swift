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
    
    enum Priority {
        case none
        case low
        case middle
        case high
        
        func toString() -> String {
            switch (self) {
            case .none: return ""
            case .low: return "!"
            case .middle: return "!!"
            case .high: return "!!!"
            }
        }
    }
    
}
