//
//  DetailsViewController.swift
//  Reminders_UIKit
//
//  Created by jiyeon on 11/30/23.
//

import UIKit

import RxRelay
import RxSwift

protocol DetailsDelegate {
    func didTapDoneButton()
}

class DetailsViewController: BaseViewController<DetailsView> {
    
    // MARK: Properties
    
    let disposeBag = DisposeBag()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        bind()
    }
    
    // MARK: Functions
    
    private func configureNavigationItem() {
        self.navigationItem.title = "세부사항"
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.rightBarButtonItem = baseView.doneButton
        self.view.backgroundColor = .tertiarySystemGroupedBackground
    }
    
    private func bind() {
        baseView.delegate = self
    }
    
    func bind(reminderRelay: BehaviorRelay<Reminder>) {
        baseView.bind(reminderRelay: reminderRelay)
    }
    
}

extension DetailsViewController: DetailsDelegate {
    
    func didTapDoneButton() {
        self.dismiss(animated: true)
    }
    
}
