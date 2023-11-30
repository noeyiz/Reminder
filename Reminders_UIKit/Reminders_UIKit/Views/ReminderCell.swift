//
//  ReminderCell.swift
//  Reminders_UIKit
//
//  Created by jiyeon on 11/30/23.
//

import UIKit

import RxRelay
import RxSwift
import SnapKit
import Then

class ReminderCell: UITableViewCell {
    
    // MARK: Properties
    
    let disposeBag = DisposeBag()
    
    var reminderRelay: BehaviorRelay<Reminder>?
    
    // MARK: UI
    
    let titleTextView = UITextView().then {
        $0.isScrollEnabled = false
        $0.font = .systemFont(ofSize: 15)
        $0.backgroundColor = .systemBrown
    }
    
    
    // MARK: Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure UI
    
    private func configureUI() {
        // 서브뷰 추가
        contentView.addSubview(titleTextView)
        
        // 제약 사항 설정
        titleTextView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    // MARK: Bind
    
    func bind(reminderRelay: BehaviorRelay<Reminder>) {
        self.reminderRelay = reminderRelay
        
        reminderRelay.subscribe(onNext: { [weak self] reminder in
            self?.titleTextView.text = reminder.title
        }).disposed(by: disposeBag)
        
        titleTextView.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { title in
                var reminder = reminderRelay.value
                reminder.title = title
                reminderRelay.accept(reminder)
            }).disposed(by: disposeBag)
    }
    
}
