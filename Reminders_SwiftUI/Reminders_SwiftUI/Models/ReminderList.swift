//
//  ReminderList.swift
//  Reminders_SwiftUI
//
//  Created by jiyeon on 12/4/23.
//

import SwiftUI

struct ReminderList: Identifiable {
    let id: UUID = UUID()
    var name: String
    var reminders = [Reminder]()
    var color = Color.blue
    var iconName = "list.bullet"
}

extension ReminderList {
    static var defaultList: ReminderList {
        ReminderList(name: "Reminders", reminders: [Reminder.defaultReminder])
    }
}
