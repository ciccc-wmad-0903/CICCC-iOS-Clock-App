//
//  TimeZonesTableViewCell.swift
//  Clock
//
//  Created by Mac on 2020-06-05.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

class TimeZonesTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle , reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        textLabel?.textColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
