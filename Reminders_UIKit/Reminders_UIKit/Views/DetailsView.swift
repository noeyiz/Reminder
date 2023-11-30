//
//  DetailsView.swift
//  Reminders_UIKit
//
//  Created by jiyeon on 11/30/23.
//

import UIKit

import SnapKit
import Then

class DetailsView: UIView {
    
    // MARK: UI
    
    
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
        backgroundColor = .tertiarySystemGroupedBackground
    }
    
    // MARK: Functions
    
    @objc private func hideKeyboard(_ sender: Any) {
        self.endEditing(true)
    }
    
}
