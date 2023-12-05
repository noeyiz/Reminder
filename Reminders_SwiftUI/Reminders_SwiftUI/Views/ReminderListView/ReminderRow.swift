//
//  ReminderRow.swift
//  Reminders_SwiftUI
//
//  Created by jiyeon on 12/4/23.
//

import SwiftUI

struct ReminderRow: View {
    @Binding var reminder: Reminder
    @Binding var focused: Reminder?
    @FocusState var isFocused: Bool
    let color: Color

    var body: some View {
        HStack {
            Button {
                reminder.isComplete.toggle()
            } label: {
                Image(systemName: reminder.isComplete ? "circle.inset.filled" : "circle")
                    .foregroundStyle(color)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            TextField(reminder.name, text: $reminder.name)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .onAppear {
                    isFocused = reminder == focused
                }
                .focused($isFocused)
        }
    }
}

#Preview {
    ReminderRow(reminder: .constant(Reminder.defaultReminder), focused: .constant(Reminder.defaultReminder), color: Color.blue)
}
