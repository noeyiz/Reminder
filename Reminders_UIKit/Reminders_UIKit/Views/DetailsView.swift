//
//  DetailsView.swift
//  Reminders_UIKit
//
//  Created by jiyeon on 11/30/23.
//

import UIKit

import RxRelay
import RxSwift
import SnapKit
import Then
import UITextView_Placeholder

class DetailsView: UIView {
    
    // MARK: Properties
    
    let disposeBag = DisposeBag()
    
    var reminder: BehaviorRelay<Reminder>?
    
    var delegate: DetailsDelegate?
    
    var priority: Reminder.Priority? {
        didSet {
            priorityMenuButton.configuration?.title = self.priority?.toString()
        }
    }
    
    // MARK: UI
    
    let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: nil, action: nil)
    
    let detailStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.backgroundColor = .systemBackground
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
        $0.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    let titleTextView = UITextView().then {
        $0.placeholder = "Title"
        $0.isScrollEnabled = false
        $0.font = .systemFont(ofSize: 15)
    }
    
    let notesTextView = UITextView().then {
        $0.placeholder = "Notes"
        $0.isScrollEnabled = false
        $0.font = .systemFont(ofSize: 15)
    }
    
    let separatorView = UIView().then {
        $0.backgroundColor = .systemGray5
    }
    
    let priorityStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.backgroundColor = .systemBackground
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
        $0.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    let priorityImageView = UIImageView().then {
        $0.image = UIImage(systemName: "exclamationmark.square.fill")
        $0.tintColor = .systemRed
    }
    
    let priorityLabel = UILabel().then {
        $0.text = "Priority"
        $0.font = UIFont.systemFont(ofSize: 15)
    }
    
    let priorityMenuButton = UIButton().then {
        $0.showsMenuAsPrimaryAction = true // 메뉴를 기본 동작으로
        $0.configuration = UIButton.Configuration.plain()
        $0.configuration?.image = UIImage(systemName: "chevron.up.chevron.down")
        $0.configuration?.preferredSymbolConfigurationForImage = .init(pointSize: 15)
        $0.configuration?.imagePadding = 5
        $0.configuration?.imagePlacement = .trailing
        $0.tintColor = .systemGray2
    }
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure UI
    
    private func configureUI() {
        backgroundColor = .tertiarySystemGroupedBackground
        
        // 서브뷰 추가
        addSubview(detailStackView)
        detailStackView.addArrangedSubview(titleTextView)
        detailStackView.addArrangedSubview(separatorView)
        detailStackView.addArrangedSubview(notesTextView)
        addSubview(priorityStackView)
        priorityStackView.addArrangedSubview(priorityImageView)
        priorityStackView.addArrangedSubview(priorityLabel)
        priorityStackView.addArrangedSubview(priorityMenuButton)
        
        // 제약 사항 설정
        detailStackView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview().inset(20)
        }
        
        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        priorityStackView.snp.makeConstraints {
            $0.top.equalTo(self.detailStackView.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
        }
        
        priorityImageView.snp.makeConstraints {
            $0.width.height.equalTo(35)
        }
    }
    
    // MARK: Functions
    
    private func bind() {
        titleTextView.delegate = self
        notesTextView.delegate = self
        
        // 메뉴 설정
        let menuItems = Reminder.Priority.allCases.map { priority -> UIAction in
            let title = "\(priority.toString())"
            return UIAction(title: title, image: nil) { _ in
                self.priority = priority
            }
        }
        priorityMenuButton.menu = UIMenu(identifier: nil,
                         options: .displayInline,
                         children: menuItems)
        
        doneButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let reminderRelay = self?.reminder else { return }
                
                var reminder = reminderRelay.value
                reminder.title = self?.titleTextView.text ?? ""
                reminder.notes = self?.notesTextView.text
                reminder.priority = self?.priority ?? reminder.priority
                reminderRelay.accept(reminder)
                
                self?.delegate?.didTapDoneButton()
            }).disposed(by: disposeBag)
        
        self.addGestureRecognizer( // 테이블 뷰 스크롤을 위해 터치가 막혀있어서 제스처 사용
            UITapGestureRecognizer(
                target: self,
                action: #selector(hideKeyboard(_:))
            )
        )
    }
    
    func bind(reminderRelay: BehaviorRelay<Reminder>?) {
        guard let reminderRelay = reminderRelay else { return }
        
        reminder = reminderRelay // reference 기억
        
        reminderRelay.subscribe(onNext: { [weak self] reminder in
            self?.titleTextView.text = reminder.title
            self?.notesTextView.text = reminder.notes
            self?.priorityMenuButton.configuration?.title = reminder.priority.toString()
        }).disposed(by: disposeBag)
    }
    
    @objc private func hideKeyboard(_ sender: Any) {
        self.endEditing(true)
    }
    
}

extension DetailsView: UITextViewDelegate {
    
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
    
}
