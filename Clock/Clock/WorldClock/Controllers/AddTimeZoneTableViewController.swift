//
//  AddTimeZoneTableViewController.swift
//  Clock
//
//  Created by Mac on 2020-06-03.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

protocol WorldClockProtocol {
    func addTimeZone(timeZone: String)
    
}

class AddTimeZoneTableViewController: UITableViewController, UISearchBarDelegate {
    
    private let TimeZoneID = "TimeZoneID"
    private var timeZones: [String] = []
    private let searchBar = UISearchBar(frame: .zero)
    var delegate: WorldClockProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        navigationItem.title = "Choose a City"
        self.navigationItem.rightBarButtonItem?.tintColor = .mainTintColor
        self.view.backgroundColor = .darkGray
        self.navigationController?.navigationBar.backgroundColor = .gray

        tableView.register(TimeZonesTableViewCell.self, forCellReuseIdentifier: TimeZoneID)

        timeZones = NSTimeZone.knownTimeZoneNames
        
        searchBarConstrains()
    }

    private func searchBarConstrains() {
        navigationController?.navigationBar.addSubview(searchBar)
        searchBar.sizeToFit()
        searchBar.placeholder = "Search"
        searchBar.backgroundColor = .lightGray
        searchBar.delegate = self
        searchBar.showsCancelButton = true

    }
        
// MARK: - Table view data

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeZones.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimeZoneID, for: indexPath) as! TimeZonesTableViewCell
        cell.textLabel?.text = timeZones[indexPath.row]
        cell.backgroundColor = .gray
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let SelectedTZ: String = timeZones[indexPath.row]
        delegate?.addTimeZone(timeZone: SelectedTZ)
        
        self.dismiss(animated: true, completion: nil)
//        print(SelectedTZ)
        
    }

// MARK: - SearchBar

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
   
    func searchBar(_ searchBar: UISearchBar, textDidChange: String) {
        if !textDidChange.isEmpty  {
            timeZones = NSTimeZone.knownTimeZoneNames.filter { $0.contains(textDidChange)}
        } else {
            timeZones = NSTimeZone.knownTimeZoneNames
        }
        tableView?.reloadData()
    }
    
}
