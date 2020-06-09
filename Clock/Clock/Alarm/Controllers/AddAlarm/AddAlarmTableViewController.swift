//
//  AddAlarmTableViewController.swift
//  Clock
//
//  Created by AaronH on 2020-06-01.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit
import Foundation

class AddAlarmTableViewController: UITableViewController {
    
    var widthAnchor: NSLayoutConstraint?
    var heightAnchor: NSLayoutConstraint?
    
    let mainView: UIView = {
        let main = UIView()
        // important when setting contraints programmatically
        main.translatesAutoresizingMaskIntoConstraints = false
        main.backgroundColor = .black
        return main
    }()
    
    //    var segueInfo: SegueInfo!
    var datepicker : UIDatePicker {
        var datepicker = UIDatePicker()
        datepicker.translatesAutoresizingMaskIntoConstraints = false
        datepicker = UIDatePicker.init(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.width, height:150))
        datepicker.setValue(UIColor(red:0.95, green:0.92, blue:0.90, alpha:1.0), forKeyPath: "textColor")
        datepicker.datePickerMode = .time
        return datepicker
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Add Alarm"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: nil)
        view.backgroundColor = .black
        view.addSubview(mainView)
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        mainView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        widthAnchor = mainView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7, constant: 0)
        widthAnchor?.isActive = true
        
        heightAnchor = mainView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7, constant: 0)
        heightAnchor?.isActive = true
        
        datepicker.frame = CGRect(x: 0, y: 40, width: self.view.frame.width, height: 200)
        
        mainView.addSubview(datepicker)

//        table = UITableView(frame: CGRect(x: 100, y: 250, width: 252, height: 150))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset.top = 120
        tableView.verticalScrollIndicatorInsets.top = 120
        tableView.keyboardDismissMode = .interactive
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "id")
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        //        if segueInfo.isEditMode {
        //            return 2
        //        }
        //        else {
        return 1
        //        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }
        else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "settingIdentifier")
        if(cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "settingIdentifier")
        }
        if indexPath.section == 0 {
            if indexPath.row == 0 {
            } else if indexPath.row == 1 {
                cell!.textLabel!.text = "Repeat"
                //                cell!.detailTextLabel!.text = WeekdaysViewController.repeatText(weekdays: segueInfo.repeatWeekdays)
                //                cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            } else if indexPath.row == 2 {
                cell!.textLabel!.text = "Label"
                //                cell!.detailTextLabel!.text = segueInfo.label
                //                cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
            else if indexPath.row == 3 {
                cell!.textLabel!.text = "Sound"
                //                cell!.detailTextLabel!.text = segueInfo.mediaLabel
                //                cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
            else if indexPath.row == 4 {
                
                cell!.textLabel!.text = "Snooze"
                //                let sw = UISwitch(frame: CGRect())
                //                sw.addTarget(self, action: #selector(AlarmAddEditViewController.snoozeSwitchTapped(_:)), for: UIControlEvents.touchUpInside)
                //
                //                if snoozeEnabled {
                //                   sw.setOn(true, animated: false)
                //                }
                //
                //                cell!.accessoryView = sw
            }
        }
        else if indexPath.section == 1 {
            //            cell = UITableViewCell(
            //                style: UITableViewCellStyle.default, reuseIdentifier: Id.settingIdentifier)
            cell!.textLabel!.text = "Delete Alarm"
            //            cell!.textLabel!.textAlignment = .center
            //            cell!.textLabel!.textColor = UIColor.red
        }
        
        return cell!
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let _ = tableView.cellForRow(at: indexPath)
        //        if indexPath.section == 0 {
        //            switch indexPath.row{
        //            case 0:
        //                performSegue(withIdentifier: Id.weekdaysSegueIdentifier, sender: self)
        //                cell?.setSelected(true, animated: false)
        //                cell?.setSelected(false, animated: false)
        //            case 1:
        //                performSegue(withIdentifier: Id.labelSegueIdentifier, sender: self)
        //                cell?.setSelected(true, animated: false)
        //                cell?.setSelected(false, animated: false)
        //            case 2:
        //                performSegue(withIdentifier: Id.soundSegueIdentifier, sender: self)
        //                cell?.setSelected(true, animated: false)
        //                cell?.setSelected(false, animated: false)
        //            default:
        //                break
        //            }
        //        }
        //        else if indexPath.section == 1 {
        //            //delete alarm
        //            alarmModel.alarms.remove(at: segueInfo.curCellIndex)
        //            performSegue(withIdentifier: Id.saveSegueIdentifier, sender: self)
        //        }
        //
    }
}
