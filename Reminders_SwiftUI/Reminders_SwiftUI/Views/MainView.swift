//
//  MainView.swift
//  Reminders_SwiftUI
//
//  Created by jiyeon on 12/4/23.
//

import SwiftUI

struct MainView: View {
    @State private var isPresented = false
    @State var reminderLists = [ReminderList.defaultList]
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    Section {
                        ForEach($reminderLists) { $reminderList in
                            NavigationLink {
                                ReminderListView(reminderList: $reminderList)
                            } label: {
                                ReminderListRow(reminderList: reminderList)
                            }
                        }
                    } header: {
                        Text("My List")
                            .font(.system(.title3, design: .rounded, weight: .bold))
                            .foregroundColor(.primary)
                    }
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button("Add List") {
                            isPresented.toggle()
                        }
                        .padding()
                        .sheet(isPresented: $isPresented) {
                            AddListView(isPresented: $isPresented) { newList in
                                reminderLists.append(newList)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Reminders")
        }
    }
}

#Preview {
    MainView()
}
