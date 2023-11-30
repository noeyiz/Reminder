//
//  MainViewController.swift
//  Reminders_UIKit
//
//  Created by jiyeon on 11/28/23.
//

import UIKit

class MainViewController: BaseViewController<MainView> {

    // MARK: Initializer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
    }

    // MARK: Configure
    
    private func configureNavigationItem() {
        self.navigationItem.title = "미리 알림"
        self.navigationItem.rightBarButtonItem = self.baseView.menuButton
    }

}

