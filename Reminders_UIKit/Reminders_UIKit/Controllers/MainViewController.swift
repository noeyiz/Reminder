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
    
    // MARK: Properties
    
    let disposeBag = DisposeBag()
    
    let reminderManager = ReminderManager.instance
    
    // MARK: Initializer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        bind()
    }
    
    // MARK: Functions
    
    private func configureNavigationItem() {
        self.navigationItem.title = "미리 알림"
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationItem.rightBarButtonItem = self.baseView.menuButton
    }
    
    private func bind() {
        self.baseView.remindersTableView.delegate = self
        self.baseView.remindersTableView.dataSource = self
        
        self.baseView.menuButton.rx.tap
            .subscribe(onNext: {
                print("menu button tap")
                for reminder in self.reminderManager.reminders.value {
                    print("\(reminder.value)\n")
                }
                print("\n\n")
            }).disposed(by: disposeBag)
        
        self.baseView.addReminderButton.rx.tap
            .subscribe(onNext: {
                print("add reminder button tap")
                self.reminderManager.addReminder()
                self.baseView.remindersTableView.reloadData()
            }).disposed(by: disposeBag)
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminderManager.reminders.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell")
                as? ReminderCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.bind(reminderRelay: reminderManager.reminders.value[indexPath.row])
        cell.titleTextView.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            reminderManager.deleteReminder(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

extension MainViewController: UITextViewDelegate {
    
    // 🐥 텍스트 뷰 내용에 따른 동적 높이 설정
    func textViewDidChange(_ textView: UITextView) {
        let tableView = self.baseView.remindersTableView
        
        let contentSize = textView.sizeThatFits(CGSize(width: textView.bounds.width, height: .infinity))
        
        if textView.bounds.height != contentSize.height {
            tableView.contentOffset.y += contentSize.height - textView.bounds.height
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
}
