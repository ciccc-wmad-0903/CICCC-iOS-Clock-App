//
//  TimerSelectSoundTableView.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-11.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

class TimerSelectSoundTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .insetGrouped)
        
        setupTableViewProperties()
    }
    
    func setSelectedSoundName(selectedSoundName: String) {
        cellForRow(at: IndexPath(row: 0, section: 0))?.detailTextLabel?.text = selectedSoundName
    }
    
    private func setupTableViewProperties() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        isScrollEnabled = false
        rowHeight = 50
        register(TimerSelectSoundTableViewCell.self, forCellReuseIdentifier: TimerSelectSoundTableViewCell.reuseIdentifier)
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension TimerSelectSoundTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: TimerSelectSoundTableViewCell.reuseIdentifier, for: indexPath)
    }
    
}
