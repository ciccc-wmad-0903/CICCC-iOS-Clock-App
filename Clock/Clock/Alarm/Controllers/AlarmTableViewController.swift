//
//  AlarmTableViewController.swift
//  Clock
//
//  Created by Kaden Kim on 2020-05-28.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

class AlarmTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    // Need to be uncommented
    private var alarms: [Alarm] = [] {
        didSet {
            saveAlarms()
            // TODO: UserNotification update/setup
        }
    }

    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAlarms()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewAlarmTapped(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = .mainTintColor
        self.navigationItem.rightBarButtonItem?.tintColor = .mainTintColor
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AlarmTableViewCell.self, forCellReuseIdentifier: AlarmTableViewCell.reuseIdentifier)
        tableView.allowsSelection = false
        tableView.allowsSelectionDuringEditing = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Methods
    func addAlarm(_ newAlarm: Alarm) {
        alarms.append(newAlarm)
        tableView.reloadData()
    }
    
    func editAlarm(_ index: Int, _ editedAlarm: Alarm?) {
        alarms.remove(at: index)
        if let alarm = editedAlarm { alarms.insert(alarm, at: index) }
        tableView.reloadData()
    }
    
    @objc private func addNewAlarmTapped(_ sender: UIBarButtonItem){
        let addNewAlarmTVC = AddEditAlarmTableViewController(style: .grouped)
        addNewAlarmTVC.addAlarm = addAlarm
        present(UINavigationController(rootViewController: addNewAlarmTVC), animated: true, completion: nil)
    }
    
    private func editAlarmTapped(index: Int) {
        setEditing(false, animated: true)
        let addNewAlarmTVC = AddEditAlarmTableViewController(style: .grouped)
        addNewAlarmTVC.editOrDeleteAlarm = editAlarm
        addNewAlarmTVC.editIndex = index
        present(UINavigationController(rootViewController: addNewAlarmTVC), animated: true, completion: nil)
    }
    
    @objc private func changedAlarmEnable(_ sender: UISwitch) {
        alarms[sender.tag].isEnable = sender.isOn
        (tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! AlarmTableViewCell).setTextColors(sender.isOn)
    }
    
    // MARK: - Service Methods
    private let plistFileName = "alarms"
    private func saveAlarms() {
        Persistence.saveData(data: alarms, plistName: plistFileName)
    }
    
    private func loadAlarms() {
        alarms = Persistence.loadData([Alarm].self, plistName: plistFileName) ?? []
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlarmTableViewCell.reuseIdentifier, for: indexPath) as! AlarmTableViewCell
        let accessorySwitch = UISwitch()
        cell.accessoryView = accessorySwitch
        cell.editingAccessoryType = .disclosureIndicator
        
        let alarm = alarms[indexPath.row]
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        let timeStrings = timeFormatter.string(from: alarm.alarm).split(separator: " ")
        cell.timeLabel.text = String(timeStrings[0])
        cell.timeAPMLabel.text = String(timeStrings[1])
        cell.labelRepeatLabel.text = "\(alarm.label), \(alarm.repeatableToString())"
        cell.setTextColors(alarm.isEnable)
        
        accessorySwitch.isOn = alarm.isEnable
        accessorySwitch.tag = indexPath.row
        accessorySwitch.addTarget(self, action: #selector(changedAlarmEnable(_:)), for: .valueChanged)
        accessorySwitch.isHidden = self.isEditing
        
        return cell
    }
    
    // MARK: - Table view delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if isEditing { editAlarmTapped(index: indexPath.row) }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [
            UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, handler) in
                self?.alarms.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                handler(true)
            }
        ])
    }
    
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        setEditing(false, animated: true)
        tableView.reloadData()
    }
    
}
