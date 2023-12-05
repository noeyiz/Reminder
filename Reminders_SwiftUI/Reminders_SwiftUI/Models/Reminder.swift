//
//  Reminder.swift
//  Reminders_SwiftUI
//
//  Created by jiyeon on 12/4/23.
//

import Foundation

struct Reminder: Equatable, Identifiable {
    let id: UUID = UUID()
    var name: String = ""
    var isComplete: Bool = false
}

extension Reminder {
    static var defaultReminder: Reminder {
        Reminder(name: "goojiong")
    }
}
