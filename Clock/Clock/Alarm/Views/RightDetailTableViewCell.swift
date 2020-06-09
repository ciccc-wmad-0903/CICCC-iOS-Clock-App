//
//  RightDetailTableViewCell.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-08.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

class RightDetailTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        backgroundColor = .rightDetailCellBackgroundColor
        textLabel?.textColor = .white
        textLabel?.font = .systemFont(ofSize: 15)
        detailTextLabel?.font = .systemFont(ofSize: 15)
    }
    
    convenience init(title: String) {
        self.init()
        textLabel?.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
