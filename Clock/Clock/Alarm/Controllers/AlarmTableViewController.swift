//
//  AlarmTableViewController.swift
//  Clock
//
//  Created by Kaden Kim on 2020-05-28.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

class AlarmTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem?.tintColor = .mainTintColor
        self.navigationItem.rightBarButtonItem?.tintColor = .mainTintColor
        
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
}
