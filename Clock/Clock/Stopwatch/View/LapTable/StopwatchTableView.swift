//
//  StopwatchTableView.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-07.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

class StopwatchTableView: UITableView {
    
    var laps = [Lap]()

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        setupTableViewProperties()
    }
    
    private func setupTableViewProperties() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .black
        separatorInset = .zero
        separatorColor = .tableViewSeparatorColor
        register(StopwatchLapsTableViewCell.self, forCellReuseIdentifier: StopwatchLapsTableViewCell.reuseIdentifier)
        dataSource = self
        delegate = self
        
        let line = UIView(frame: CGRect(x: 20, y: 0, width: self.frame.size.width - 36, height: 1 / UIScreen.main.scale))
        line.backgroundColor = .tableViewSeparatorColor
        tableHeaderView = line
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension StopwatchTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : laps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StopwatchLapsTableViewCell.reuseIdentifier, for: indexPath) as! StopwatchLapsTableViewCell
        if indexPath.section == 1 {
            let data = laps[laps.count - indexPath.row - 1]
            cell.lapNumberLabel.text = "Lap \(laps.count - indexPath.row)"
            cell.lapRecordLabel.text = data.lapString
            cell.setTextColor(min: data.min, max: data.max, normal: !(data.min || data.max))
        }
        return cell
    }
    
}

extension StopwatchTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 7.3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
}
