//
//  BaseViewController.swift
//  Reminders_UIKit
//
//  Created by jiyeon on 11/30/23.
//

import UIKit

import SnapKit

class BaseViewController<BaseView: UIView>: UIViewController {
    
    // MARK: UI
    
    let baseView = BaseView()
    
    // MAKR: Initializer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(baseView)
        baseView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(self.navigationController?.navigationBar.frame.maxY ?? 0)
            $0.left.bottom.right.equalToSuperview()
        }
    }
    
}
