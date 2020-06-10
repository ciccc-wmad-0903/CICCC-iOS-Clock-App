//
//  AlarmTableViewCell.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-09.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

class AlarmTableViewCell: ClockTableViewCell {
    
    lazy var timeLabel: UILabel = {
        let tl = UILabel()
        tl.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        tl.translatesAutoresizingMaskIntoConstraints = false
        tl.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        tl.font = .systemFont(ofSize: 60, weight: .thin)
        tl.textColor = .white
        return tl
    }()
    
    lazy var timeAPMLabel: UILabel = {
        let apl = UILabel()
        apl.setContentHuggingPriority(.defaultLow, for: .horizontal)
        apl.translatesAutoresizingMaskIntoConstraints = false
        apl.setContentCompressionResistancePriority(.required, for: .horizontal)
        apl.font = .systemFont(ofSize: 30, weight: .light)
        apl.textColor = .white
        return apl
    }()
    
    lazy var labelRepeatLabel: UILabel = {
        let lrl = UILabel()
        lrl.translatesAutoresizingMaskIntoConstraints = false
        lrl.setContentCompressionResistancePriority(.required, for: .vertical)
        lrl.font = .systemFont(ofSize: 15)
        lrl.textColor = .white
        return lrl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        
        contentView.addSubview(timeLabel)
        contentView.addSubview(timeAPMLabel)
        contentView.addSubview(labelRepeatLabel)
        
        labelRepeatLabel.anchors(topAnchor: contentView.topAnchor,
                                 leadingAnchor: contentView.leadingAnchor,
                                 trailingAnchor: contentView.trailingAnchor,
                                 bottomAnchor: contentView.bottomAnchor,
                                 padding: .init(top: 65, left: 24, bottom: 12, right: 24))
        timeLabel.anchors(topAnchor: contentView.topAnchor,
                          leadingAnchor: contentView.leadingAnchor,
                          trailingAnchor: nil,
                          bottomAnchor: labelRepeatLabel.topAnchor,
                          padding: .init(top: 0, left: 24, bottom: 0, right: 0))
        timeAPMLabel.anchors(topAnchor: nil,
                             leadingAnchor: timeLabel.trailingAnchor,
                             trailingAnchor: contentView.trailingAnchor,
                             bottomAnchor: labelRepeatLabel.topAnchor,
                             padding: .init(top: 0, left: 0, bottom: 0, right: 24))
        
    }
    
    @objc func setTextColors(_ isEnable: Bool) {
        let color: UIColor = isEnable ? .white : .alarmDisableTextColor
        timeLabel.textColor = color
        timeAPMLabel.textColor = color
        labelRepeatLabel.textColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
