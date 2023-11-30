//
//  MainViewController.swift
//  Reminders_UIKit
//
//  Created by jiyeon on 11/28/23.
//

import UIKit

import RxCocoa
import RxSwift

protocol ReminderCellDelegate {
    func didTapDetailsButton(reminderRelay: BehaviorRelay<Reminder>)
}

class MainViewController: BaseViewController<MainView> {
    
    // MARK: Properties
    
    let disposeBag = DisposeBag()
    
    let reminderManager = ReminderManager.instance
    
    // MARK: Life Cycle
    
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
        self.view.backgroundColor = .systemBackground
    }
    
    private func bind() {
        baseView.remindersTableView.delegate = self
        baseView.remindersTableView.dataSource = self
        
        baseView.menuButton.rx.tap
            .subscribe(onNext: { [weak self] in
                print("menu button tap")
                for reminder in self!.reminderManager.reminders.value {
                    print("\(reminder.value)\n")
                }
                print("\n\n")
            }).disposed(by: disposeBag)
        
        baseView.addReminderButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.reminderManager.addReminder()
                self?.baseView.remindersTableView.reloadData()
                guard let inputCell = self?.baseView.remindersTableView.visibleCells.last as? ReminderCell
                else { return }
                inputCell.titleTextView.becomeFirstResponder()
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
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            reminderManager.deleteReminder(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

extension MainViewController: ReminderCellDelegate {
    
    func didTapDetailsButton(reminderRelay: BehaviorRelay<Reminder>) {
        let detailsViewController = DetailsViewController()
        detailsViewController.reminder = reminderRelay
        present(UINavigationController(rootViewController: detailsViewController), animated: true)
    }
    
}
