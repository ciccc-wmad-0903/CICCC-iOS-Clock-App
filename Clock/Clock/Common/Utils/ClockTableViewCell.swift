//
//  UITableViewCell+SelectedBackground.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-10.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

class ClockTableViewCell: UITableViewCell {
    
    static var darkSelectedBackgroundView: UIView {
        let view = UIView.init(frame: .zero)
        view.backgroundColor = .tableViewCellSelectedBackgroundColor
        return view
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textLabel?.textColor = .white
        backgroundColor = .black
        selectedBackgroundView = ClockTableViewCell.darkSelectedBackgroundView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
