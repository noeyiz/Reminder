//
//  MainView.swift
//  Reminders_UIKit
//
//  Created by jiyeon on 11/30/23.
//

import UIKit

import SnapKit
import Then

class MainView: UIView {
    
    // MARK: UI
    
    let menuButton = UIBarButtonItem(
        image: UIImage(systemName: "ellipsis.circle"),
        style: .plain,
        target: nil,
        action: nil
    ).then {
        $0.tintColor = .reminders
    }
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure UI
    
    private func configureUI() {
        self.backgroundColor = .systemPink
    }
    
}
