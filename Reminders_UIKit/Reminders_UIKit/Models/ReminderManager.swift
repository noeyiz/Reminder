//
//  ReminderManager.swift
//  Reminders_UIKit
//
//  Created by jiyeon on 11/30/23.
//

import Foundation

import RxRelay
import RxSwift

class ReminderManager {
    
    static let instance = ReminderManager() // 싱글톤
    private init() {}
    
    let reminders: BehaviorRelay<[BehaviorRelay<Reminder>]> = BehaviorRelay(value: [])
    
    // 새로운 Reminder를 추가하는 함수
    func addReminder() {
        let newReminderRelay = BehaviorRelay(value: Reminder())
        
        var updatedReminders = reminders.value
        updatedReminders.append(newReminderRelay)
        reminders.accept(updatedReminders)
    }
    
    // Reminder를 삭제하는 함수
    func deleteReminder(at index: Int) {
        guard index >= 0 && index < reminders.value.count else { return }
        
        var updatedReminders = reminders.value
        updatedReminders.remove(at: index)
        reminders.accept(updatedReminders)
    }
    
}
