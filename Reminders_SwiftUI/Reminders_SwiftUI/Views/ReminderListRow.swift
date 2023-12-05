//
//  ReminderListRow.swift
//  Reminders_SwiftUI
//
//  Created by jiyeon on 12/4/23.
//

import SwiftUI

struct ReminderListRow: View {
    let reminderList: ReminderList
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(reminderList.color)
                    .frame(width: 30)
                Image(systemName: reminderList.iconName)
                    .font(.footnote)
                    .foregroundStyle(.white)
                    .bold()
            }
            Text(reminderList.name)
            Spacer()
            Text(String(reminderList.reminders.count))
                .foregroundStyle(.gray)
        }
    }
}
