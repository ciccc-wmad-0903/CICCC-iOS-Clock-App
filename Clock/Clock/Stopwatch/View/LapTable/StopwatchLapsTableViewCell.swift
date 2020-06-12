//
//  TableViewCell.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-06.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

class StopwatchLapsTableViewCell: UITableViewCell {
    
    lazy var lapNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .white
        label.font = .monospacedDigitSystemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    lazy var lapRecordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.textColor = .white
        label.font = .monospacedDigitSystemFont(ofSize: 14, weight: .medium)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .black
        contentView.addSubview(lapNumberLabel)
        lapNumberLabel.anchors(topAnchor: nil, leadingAnchor: contentView.leadingAnchor, trailingAnchor: nil, bottomAnchor: nil)
        lapNumberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        contentView.addSubview(lapRecordLabel)
        lapRecordLabel.anchors(topAnchor: nil, leadingAnchor: nil, trailingAnchor: contentView.trailingAnchor, bottomAnchor: nil)
        lapRecordLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    func setTextColor(min: Bool = false, max: Bool = false, normal: Bool = true) {
        if min || max {
            lapNumberLabel.textColor = max ? .systemRed : .systemGreen
            lapRecordLabel.textColor = max ? .systemRed : .systemGreen
        } else {
            lapNumberLabel.textColor = .white
            lapRecordLabel.textColor = .white
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
