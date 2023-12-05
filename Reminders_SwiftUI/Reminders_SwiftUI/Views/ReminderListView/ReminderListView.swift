//
//  ReminderListView.swift
//  Reminders_SwiftUI
//
//  Created by jiyeon on 12/4/23.
//

import SwiftUI

struct ReminderListView: View {
    @Binding var reminderList: ReminderList
    @State var focused: Reminder? // first responder를 위해
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text(reminderList.name)
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .foregroundColor(reminderList.color)
                List {
                    ForEach($reminderList.reminders) { $reminder in
                        ReminderRow(reminder: $reminder, focused: $focused, color: reminderList.color)
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(.inset)
            }
            .padding()
            .onTapGesture {
                hideKeyboard()
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        let _ = print("\(reminderList.reminders)\n\n")
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundStyle(reminderList.color)
                    }
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        let reminder = Reminder()
                        reminderList.reminders.append(reminder)
                        focused = reminder
                    } label: {
                        HStack(spacing: 7) {
                            Image(systemName: "plus.circle.fill")
                            Text("New Reminder")
                        }
                        .font(.system(.body, design: .rounded))
                        .bold()
                        .foregroundStyle(reminderList.color)
                    }
                    Spacer()
                }
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        reminderList.reminders.remove(atOffsets: offsets)
    }
}
