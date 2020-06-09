//
//  DatePickerTableViewCell.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-08.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

class DatePickerTableViewCell: UITableViewCell {

    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.translatesAutoresizingMaskIntoConstraints = false
        dp.setValue(UIColor.white, forKeyPath: "textColor")
        dp.backgroundColor = .modalViewBackground
        dp.tintColor = .white
        return dp
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        contentView.addSubview(datePicker)
        datePicker.matchParent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
