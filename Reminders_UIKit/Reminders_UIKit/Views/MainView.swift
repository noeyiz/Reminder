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
    ).then {
        $0.tintColor = .reminders
    }
    
    let addReminderButton = UIButton().then {
        $0.configuration = UIButton.Configuration.plain()
        $0.configuration?.title = "새로운 미리 알림"
        $0.configuration?.image = UIImage(systemName: "plus.circle.fill")
        $0.configuration?.preferredSymbolConfigurationForImage = .init(pointSize: 20)
        $0.configuration?.imagePadding = 10
        $0.tintColor = .reminders
    }
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure UI
    
    private func configureUI() {
        // 서브뷰 추가
        self.addSubview(addReminderButton)
        
        // 제약 사항 설정
        addReminderButton.snp.makeConstraints {
            $0.width.equalTo(180)
            $0.height.equalTo(40)
            $0.left.equalToSuperview()
            $0.bottom.equalToSuperview().inset(50)
        }
    }
    
}
