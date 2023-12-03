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
import UITextView_Placeholder

class ReminderCell: UITableViewCell {
    
    // MARK: Properties
    
    var disposeBag: DisposeBag?
    
    var reminder: BehaviorRelay<Reminder>?
    
    var delegate: ReminderDelegate?
    
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
        $0.font = .systemFont(ofSize: 16)
    }
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    let titleTextView = UITextView().then {
        $0.isScrollEnabled = false
        $0.font = .systemFont(ofSize: 15)
    }
    
    let notesTextView = UITextView().then {
        $0.isScrollEnabled = false
        $0.textColor = .systemGray
        $0.font = .systemFont(ofSize: 12)
        $0.placeholder = "메모 추가"
    }
    
    // MARK: Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        titleTextView.delegate = self
        notesTextView.delegate = self
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
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleTextView)
        stackView.addArrangedSubview(notesTextView)
        
        // 제약 사항 설정
        completeButton.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.top.equalToSuperview().inset(5)
            $0.left.equalToSuperview().inset(10)
        }
        
        detailsButton.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.top.equalToSuperview().inset(5)
            $0.right.equalToSuperview().inset(10)
        }
        
        priorityLabel.snp.makeConstraints {
            $0.width.height.equalTo(15)
            $0.top.equalToSuperview().inset(10)
            $0.left.equalTo(self.completeButton.snp.right).offset(10)
        }
        
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(3)
            $0.left.equalTo(self.priorityLabel.snp.right).offset(5)
            $0.right.equalTo(self.detailsButton.snp.left).offset(-5)
        }
        
    }
    
    // MARK: Bind
    
    func bind(reminderRelay: BehaviorRelay<Reminder>) {
        reminder = reminderRelay // 🌟 reference 저쟝해야 함
        guard let disposeBag = self.disposeBag else { return }
        
        // Model -> View
        reminderRelay.subscribe(onNext: { [weak self] reminder in
            if (reminder.isCompleted) {
                self?.completeButton.configuration?.image = UIImage(systemName: "circle.inset.filled")
                self?.completeButton.tintColor = .reminders
            } else {
                self?.completeButton.configuration?.image = UIImage(systemName: "circle")
                self?.completeButton.tintColor = .systemGray3
            }
            self?.priorityLabel.text = reminder.priority.toMark()
            self?.titleTextView.text = reminder.title
            self?.notesTextView.text = reminder.notes ?? ""
            self?.updateNotesTextView()
        }).disposed(by: disposeBag)
        
        // View -> Model
        completeButton.rx.tap
            .subscribe(onNext: { _ in
                var reminder = reminderRelay.value
                reminder.isCompleted.toggle()
                reminderRelay.accept(reminder)
                
                if reminder.isCompleted {
                    self.titleTextView.textColor = .systemGray
                } else {
                    self.titleTextView.textColor = .black
                }
            }).disposed(by: disposeBag)
        
        titleTextView.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { title in
                var reminder = reminderRelay.value
                reminder.title = title
                reminderRelay.accept(reminder)
            }).disposed(by: disposeBag)
        
        notesTextView.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { notes in
                var reminder = reminderRelay.value
                reminder.notes = notes
                reminderRelay.accept(reminder)
            }).disposed(by: disposeBag)
        
        // action
        detailsButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let reminder = self?.reminder else { return }
                self?.endEditing(true)
                if ((self?.notesTextView.text.isEmpty) != nil) {
                    self?.notesTextView.isHidden = true
                    self?.updateTableView()
                }
                self?.delegate?.didTapDetailsButton(reminderRelay: reminder)
            }).disposed(by: disposeBag)
    }
    
    // MARK: Functions
    
    func updateTableView() {
        guard let tableView = self.superview as? UITableView else { return }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func updateNotesTextView() {
        if (notesTextView.text.isEmpty && !titleTextView.isFirstResponder) {
            notesTextView.isHidden = true
        } else {
            notesTextView.isHidden = false
        }
        updateTableView()
    }
}

extension ReminderCell: UITextViewDelegate {
    
    // 🐥 텍스트 뷰 내용에 따른 동적 높이 설정
    func textViewDidChange(_ textView: UITextView) {
        let contentSize = textView.sizeThatFits(CGSize(width: textView.bounds.width, height: .infinity))
        
        if textView.bounds.height != contentSize.height {
            updateTableView()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if notesTextView.isHidden {
            notesTextView.isHidden = false
            updateTableView()
        }
        detailsButton.isHidden = false
        detailsButton.isEnabled = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty && textView.placeholder == "" { // title 텍스트뷰는 항상 비어있지 않도록
            textView.text = "새로운 미리 알림"
        }
        if notesTextView.text.isEmpty {
            notesTextView.isHidden = true
            updateTableView()
        }
        detailsButton.isHidden = true
        detailsButton.isEnabled = false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" && textView.placeholder == "" { // title 텍스트뷰에서 엔터 감지
            if textView.text.isEmpty {
                textView.text = "새로운 미리 알림"
            }
            textView.resignFirstResponder()
        }
        return true
    }
    
}
