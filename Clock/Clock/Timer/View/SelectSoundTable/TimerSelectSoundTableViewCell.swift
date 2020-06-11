//
//  SelectSoundTableViewCell.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-11.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

class TimerSelectSoundTableViewCell: ClockTableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        backgroundColor = .modalViewBackground
        textLabel?.text = "When Timer Ends"
        textLabel?.textColor = .white
        textLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        detailTextLabel?.textColor = .timerSoundNameColor
        detailTextLabel?.font = .systemFont(ofSize: 14)
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
