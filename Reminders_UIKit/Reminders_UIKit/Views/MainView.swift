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
    )
    
    let addReminderButton = UIButton().then {
        $0.configuration = UIButton.Configuration.plain()
        $0.configuration?.attributedTitle = .init(
            "새로운 미리 알림",
            attributes: .init([.font: UIFont.systemFont(ofSize: 17, weight: .medium)])
        )
        $0.configuration?.image = UIImage(systemName: "plus.circle.fill")
        $0.configuration?.preferredSymbolConfigurationForImage = .init(pointSize: 20, weight: .bold)
        $0.configuration?.imagePadding = 8
        $0.tintColor = .reminders
    }
    
    let remindersTableView = UITableView().then {
        $0.register(ReminderCell.self, forCellReuseIdentifier: "ReminderCell")
        $0.rowHeight = UITableView.automaticDimension
    }
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        self.addGestureRecognizer( // 테이블 뷰 스크롤을 위해 터치가 막혀있어서 제스처 사용
            UITapGestureRecognizer(
                target: self,
                action: #selector(hideKeyboard(_:))
            )
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure UI
    
    private func configureUI() {
        // 서브뷰 추가
        self.addSubview(addReminderButton)
        self.addSubview(remindersTableView)
        
        // 제약 사항 설정
        addReminderButton.snp.makeConstraints {
            $0.width.equalTo(180)
            $0.height.equalTo(40)
            $0.left.equalToSuperview()
            $0.bottom.equalToSuperview().inset(40)
        }
        
        remindersTableView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.bottom.equalTo(self.addReminderButton.snp.top)//.offset(-10)
        }
    }
    
    // MARK: Functions
    
    @objc private func hideKeyboard(_ sender: Any) {
        self.endEditing(true)
    }
    
}
