//
//  View+Extension.swift
//  Reminders_SwiftUI
//
//  Created by jiyeon on 12/5/23.
//

import SwiftUI

extension View {
  func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
