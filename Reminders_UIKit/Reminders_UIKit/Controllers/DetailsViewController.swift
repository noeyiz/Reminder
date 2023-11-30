//
//  DetailsViewController.swift
//  Reminders_UIKit
//
//  Created by jiyeon on 11/30/23.
//

import UIKit

import RxRelay
import RxSwift

class DetailsViewController: BaseViewController<DetailsView> {
    
    // MARK: Properties
    
    let disposeBag = DisposeBag()
    
    var reminder: BehaviorRelay<Reminder>?
    
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
        self.view.backgroundColor = .tertiarySystemGroupedBackground
    }
    
    private func bind() {
        
    }
    
}
