//
//  ReminderCell.swift
//  Reminders_UIKit
//
//  Created by jiyeon on 11/30/23.
//

import UIKit

import RxCocoa
import RxRelay
import RxSwift
import SnapKit
import Then

class ReminderCell: UITableViewCell {
    
    // MARK: Properties
    
    let disposeBag = DisposeBag()
    
    var reminder: BehaviorRelay<Reminder>?
    
    var delegate: ReminderCellDelegate?
    
    // MARK: UI
    
    let completeButton = UIButton().then {
        $0.configuration = UIButton.Configuration.plain()
        $0.configuration?.preferredSymbolConfigurationForImage = .init(pointSize: 17)
    }
    
    let detailsButton = UIButton().then {
        $0.configuration = UIButton.Configuration.plain()
        $0.configuration?.image = UIImage(systemName: "info.circle")
        $0.configuration?.preferredSymbolConfigurationForImage = .init(pointSize: 17)
        $0.tintColor = .reminders
    }
    
    let priorityLabel = UILabel().then {
        $0.textColor = .reminders
        $0.font = .boldSystemFont(ofSize: 17)
    }
    
    let titleTextView = UITextView().then {
        $0.isScrollEnabled = false
        $0.font = .systemFont(ofSize: 15)
    }
    
    
    // MARK: Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure UI
    
    private func configureUI() {
        // 서브뷰 추가
        contentView.addSubview(completeButton)
        contentView.addSubview(detailsButton)
        contentView.addSubview(priorityLabel)
        contentView.addSubview(titleTextView)
        
        // 제약 사항 설정
        completeButton.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.left.top.equalToSuperview().inset(9)
        }
        
        detailsButton.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.right.top.equalToSuperview().inset(9)
        }
        
        priorityLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13)
            $0.left.equalTo(self.completeButton.snp.right).offset(10)
        }
        
        titleTextView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.left.equalTo(self.priorityLabel.snp.right).offset(5)
            $0.right.equalTo(self.detailsButton.snp.left).offset(-5)
        }
    }
    
    // MARK: Bind
    
    func bind(reminderRelay: BehaviorRelay<Reminder>) {
        reminder = reminderRelay // 🌟 reference 저쟝해야 함
        
        // Model -> View
        reminderRelay.subscribe(onNext: { [weak self] reminder in
            // complete button
            if (reminder.isCompleted) {
                self?.completeButton.configuration?.image = UIImage(systemName: "circle.inset.filled")
                self?.completeButton.tintColor = .reminders
            } else {
                self?.completeButton.configuration?.image = UIImage(systemName: "circle")
                self?.completeButton.tintColor = .systemGray2
            }
            // priority label
            self?.priorityLabel.text = reminder.priority.toString()
            // title textview
            self?.titleTextView.text = reminder.title
        }).disposed(by: disposeBag)
        
        // View -> Model
        completeButton.rx.tap
            .subscribe(onNext: { _ in
                var reminder = reminderRelay.value
                reminder.isCompleted.toggle()
                reminderRelay.accept(reminder)
            }).disposed(by: disposeBag)
        
        titleTextView.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { title in
                var reminder = reminderRelay.value
                reminder.title = title
                reminderRelay.accept(reminder)
            }).disposed(by: disposeBag)
    }
    
    func bind() {
        titleTextView.delegate = self
        
        detailsButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let reminder = self?.reminder else { return }
                self?.endEditing(true)
                self?.delegate?.didTapDetailsButton(reminderRelay: reminder)
            }).disposed(by: disposeBag)
    }
}

extension ReminderCell: UITextViewDelegate {
    
    // 🐥 텍스트 뷰 내용에 따른 동적 높이 설정
    func textViewDidChange(_ textView: UITextView) {
        guard let tableView = self.superview as? UITableView else { return }
        
        let contentSize = textView.sizeThatFits(CGSize(width: textView.bounds.width, height: .infinity))
        
        if textView.bounds.height != contentSize.height {
            tableView.contentOffset.y += contentSize.height - textView.bounds.height
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        detailsButton.isHidden = false
        detailsButton.isEnabled = true
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        detailsButton.isHidden = true
        detailsButton.isEnabled = false
        return true
    }
    
}
