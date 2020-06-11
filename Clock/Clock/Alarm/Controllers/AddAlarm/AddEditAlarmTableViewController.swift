//
//  AddAlarmTableViewController.swift
//  Clock
//
//  Created by AaronH on 2020-06-01.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit
import Foundation

class AddEditAlarmTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    // delegate methods
    var addAlarm: ((Alarm) -> ())?
    var editOrDeleteAlarm: ((Int, Alarm?) -> ())?
    var editIndex: Int? { didSet { isEditMode = true } }
    
    // Local properties
    private var isEditMode = false
    private var alarm: Alarm!
    
    // MARK: - UI Properties
    lazy var datePickerCell = DatePickerTableViewCell()
    
    lazy var repeatCell: RightDetailTableViewCell = {
        let cell = RightDetailTableViewCell(title: "Repeat")
        cell.accessoryType = .disclosureIndicator
        return cell
    }()
    
    lazy var labelCell: RightDetailTableViewCell = {
        let cell = RightDetailTableViewCell(title: "Label")
        cell.accessoryType = .disclosureIndicator
        return cell
    }()
    
    lazy var soundCell: RightDetailTableViewCell = {
        let cell = RightDetailTableViewCell(title: "Sound")
        cell.accessoryType = .disclosureIndicator
        return cell
    }()
    
    lazy var deleteCell: UITableViewCell = {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "deleteCell")
        cell.backgroundColor = .rightDetailCellBackgroundColor
        cell.textLabel?.text = "Delete Alarm"
        cell.textLabel?.font = .systemFont(ofSize: 15)
        cell.textLabel?.textColor = .systemRed
        cell.textLabel?.textAlignment = .center
        return cell
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        if !isEditMode, alarm == nil { alarm = Alarm() }
    }
    
    // MARK: - Methods
    @objc private func cancelTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveTapped(_ sender: UIBarButtonItem) {
        addAlarm?(alarm)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func editTapped(_ sender: UIBarButtonItem) {
        editOrDeleteAlarm?(editIndex!, alarm)
        dismiss(animated: true, completion: nil)
    }
    
    private func deleteTapped() {
        editOrDeleteAlarm?(editIndex!, nil)
        dismiss(animated: true, completion: nil)
    }
    
    private func repeatTapped() {
        let repeatCheckTVC = RepeatCheckTableViewController(style: .grouped)
        self.show(repeatCheckTVC, sender: Any?.self)
    }
    
    private func setupLayout() {
        view.backgroundColor = .modalViewBackground
        title = isEditMode ? "Edit Alarm" : "Add Alarm"
        navigationController?.navigationBar.barTintColor = .rightDetailCellBackgroundColor
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.titleTextAttributes = UIColor.whiteTextColorAttribution
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: isEditMode ? .edit : .save, target: self, action: isEditMode ? #selector(editTapped(_:)) : #selector(saveTapped(_:)))
        navigationItem.leftBarButtonItem?.tintColor = .mainTintColor
        navigationItem.rightBarButtonItem?.tintColor = .mainTintColor
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "id")
        tableView.isScrollEnabled = false
        tableView.separatorColor = .tableViewSeparatorColor
    }
    
    // MARK: - TableView Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? 3 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            datePickerCell.datePicker.datePickerMode = .time
            return datePickerCell
        case (1, 0):
            repeatCell.detailTextLabel?.text = "Never"
            return repeatCell
        case (1, 1):
            labelCell.detailTextLabel?.text = "Alarm"
            return labelCell
        case (1, 2):
            soundCell.detailTextLabel?.text = "Radar"
            return soundCell
        case (2, 0):
            deleteCell.isHidden = !isEditMode
            return deleteCell
        default: return UITableViewCell()
        }
    }
    
    // MARK: - TableView Delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (1, 0):
            repeatTapped()
            break
        case (1, 1):
            // TODO: Edit Label View
            break
        case (1, 2):
            // TODO: Sound ID Selection TableView
            break
        case (2, 0):
            deleteTapped()
        default:
            break
        }
    }
    
    private let heightForSection1_2: CGFloat = 36
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 1 {
            return 0
        }
        return heightForSection1_2
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 || section == 1 {
            return 0
        }
        return heightForSection1_2
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 {
            return UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: heightForSection1_2))
        } else {
            return UIView.init(frame: .zero)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 2 {
            return UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: heightForSection1_2))
        } else {
            return UIView.init(frame: .zero)
        }
    }
    
}
