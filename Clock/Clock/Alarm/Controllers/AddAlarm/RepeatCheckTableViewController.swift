//
//  RepeatCheckTableViewController.swift
//  Clock
//
//  Created by AaronH on 2020-06-09.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit
import Foundation

class RepeatCheckTableViewController: UITableViewController {
    
    private var days = ["Every Sunday", "Every Monday", "Every Tuesday", "Every Wednesday", "Every Thursday", "Every Friday", "Every Saturday"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .modalViewBackground
        title = "Repeat"
        navigationController?.navigationBar.barTintColor = .rightDetailCellBackgroundColor
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.titleTextAttributes = UIColor.whiteTextColorAttribution
        navigationController?.navigationBar.tintColor = .mainTintColor
    }
    @objc private func cancelTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return days.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "daysCell")
        if cell == nil {
            cell = ClockTableViewCell(style: .default, reuseIdentifier: "Cell")
            cell?.backgroundColor = .rightDetailCellBackgroundColor
            cell?.textLabel?.textColor = .white
        }

        cell?.textLabel?.text = self.days[indexPath.row]
        return cell!
    }
}
