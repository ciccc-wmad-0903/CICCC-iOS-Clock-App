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

class AddTimeZoneTableViewController: UIViewController, UISearchBarDelegate {
    
    lazy var tableView = UITableView()
    
    private let TimeZoneID = "TimeZoneID"
    private var timeZones: [String] = []
    private let searchBar = UISearchBar(frame: .zero)
    private var topView: UIView!
    var delegate: WorldClockProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.rightBarButtonItem?.tintColor = .mainTintColor
        self.view.backgroundColor = .black

        timeZones = NSTimeZone.knownTimeZoneNames
        
        searchBarConstrains()
        tableViewConstraints()
    }
    
    private func searchBarConstrains() {
        topView = UIView()
        topView.constraintHeight(equalToConstant: 80)
        topView.backgroundColor = .modalViewBackground
        topView.tintColor = .modalViewBackground
        view.addSubview(topView)
        topView.anchors(topAnchor: view.safeAreaLayoutGuide.topAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, bottomAnchor: nil)
        
        let barTitle = UILabel()
        barTitle.constraintWidth(equalToConstant: view.frame.size.width, heightEqualToConstant: 20)
        barTitle.text = "Choose a City"
        barTitle.font = .systemFont(ofSize: 15, weight: .medium)
        barTitle.textColor = .white
        barTitle.textAlignment = .center
        barTitle.setContentCompressionResistancePriority(.required, for: .vertical)
        topView.addSubview(barTitle)
        barTitle.anchors(topAnchor: topView.topAnchor, leadingAnchor: nil, trailingAnchor: nil, bottomAnchor: nil,
                         padding: .init(top: 6, left: 0, bottom: 0, right: 0))
        
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.tintColor = .mainTintColor
        searchBar.barTintColor = .modalViewBackground
        let attributes:[NSAttributedString.Key: Any] = [.foregroundColor: UIColor.mainTintColor]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        topView.addSubview(searchBar)
        searchBar.anchors(topAnchor: nil, leadingAnchor: topView.leadingAnchor, trailingAnchor: topView.trailingAnchor, bottomAnchor: topView.bottomAnchor,
                          padding: .init(top: 0, left: 6, bottom: 0, right: 6))
    }
    
    private func tableViewConstraints() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .black
        tableView.separatorColor = .tableViewSeparatorColor
        tableView.register(TimeZonesTableViewCell.self, forCellReuseIdentifier: TimeZoneID)
        view.addSubview(tableView)
        tableView.anchors(topAnchor: topView.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, bottomAnchor: view.bottomAnchor)
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
        tableView.reloadData()
    }
    
}

// MARK: - Table view data
extension AddTimeZoneTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeZones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimeZoneID, for: indexPath) as! TimeZonesTableViewCell
        cell.textLabel?.text = timeZones[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let SelectedTZ: String = timeZones[indexPath.row]
        delegate?.addTimeZone(timeZone: SelectedTZ)
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
