//
//  MainViewController.swift
//  Reminders_UIKit
//
//  Created by jiyeon on 11/28/23.
//

import UIKit

import RxCocoa
import RxSwift

class MainViewController: BaseViewController<MainView> {

    // MARK: Initializer
    
    let disposeBag = DisposeBag()
    
    // MARK: Initializer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        bind()
    }

    // MARK: Functions
    
    private func configureNavigationItem() {
        self.navigationItem.title = "미리 알림"
        self.navigationItem.rightBarButtonItem = self.baseView.menuButton
    }
    
    private func bind() {
        self.baseView.menuButton.rx.tap
            .subscribe(onNext: {
                print("menu button tap")
            }).disposed(by: disposeBag)
        
        self.baseView.addReminderButton.rx.tap
            .subscribe(onNext: {
                print("add reminder button tap")
            }).disposed(by: disposeBag)
    }

}

