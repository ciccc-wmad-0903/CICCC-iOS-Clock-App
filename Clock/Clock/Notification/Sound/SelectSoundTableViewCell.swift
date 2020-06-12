//
//  SelectSoundTableViewCell.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-11.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

class SelectSoundTableViewCell: ClockTableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        backgroundColor = .modalViewBackground
        textLabel?.textColor = .white
        textLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        detailTextLabel?.textColor = .timerLightGrayColor
        detailTextLabel?.font = .systemFont(ofSize: 14)
        imageView?.frame = CGRect.init(x: 0, y: 0, width: 32, height: 32)
        
        imageView?.image = UIImage(named: "check_icon")
        imageView?.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
