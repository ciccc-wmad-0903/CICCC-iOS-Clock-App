//
//  WorldClockTableViewController.swift
//  Clock
//
//  Created by Kaden Kim on 2020-05-28.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

class WorldClockTableViewController: UITableViewController, WorldClockProtocol {
  
    private let cellID = "cellID"
    private var TimeZonesToDisplay : [String] = ["Europe/London", "Europe/Paris", "Canada/Vancouver"]
   
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = self.editButtonItem
         navigationItem.rightBarButtonItem = UIBarButtonItem( barButtonSystemItem: .add, target: self, action: #selector(addNewTimeZone(_ :)))
        self.navigationItem.leftBarButtonItem?.tintColor = .mainTintColor
        self.navigationItem.rightBarButtonItem?.tintColor = .mainTintColor
        tableView.register(CustomCellTableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        TimeZonesToDisplay = getUserDefaults()
    }
    
    @objc func addTimeZone(timeZone: String) {
          TimeZonesToDisplay.append(timeZone)
          tableView.reloadData()
          setUserDefaults()
      
    }
    
    @objc func addNewTimeZone(_ sender: UIBarButtonItem){
        let addTimeZoneTVC = AddTimeZoneTableViewController()
        let embedNav = UINavigationController(rootViewController: addTimeZoneTVC)
        
        present(embedNav, animated: true, completion: nil)
    }
    
 // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TimeZonesToDisplay.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CustomCellTableViewCell
        cell.backgroundColor = .black
        cell.timeZoneName.text = TimeZonesToDisplay[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
   
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
//   MARK: - Edit
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            TimeZonesToDisplay.remove(at: indexPath.row)
            setUserDefaults()
            tableView.reloadData()
        }
    }
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let temp1 = TimeZonesToDisplay[sourceIndexPath.row]
        let temp2 = TimeZonesToDisplay[destinationIndexPath.row]
        
        TimeZonesToDisplay[sourceIndexPath.row] = temp2
        TimeZonesToDisplay[destinationIndexPath.row] = temp1
        
        tableView.reloadData()
        
        setUserDefaults()
    }
    
    @objc func setUserDefaults() {
        
        UserDefaults.standard.set(TimeZonesToDisplay, forKey: "WorldClocks")
        UserDefaults.standard.synchronize()
        
    }
    
    @objc func getUserDefaults() -> [String] {
        
        if UserDefaults.standard.value(forKey: "WorldClocks") != nil {
            TimeZonesToDisplay = UserDefaults.standard.value(forKey: "WorldClocks") as! [String]
        }
        
        return TimeZonesToDisplay
    }
        
    
    
}
