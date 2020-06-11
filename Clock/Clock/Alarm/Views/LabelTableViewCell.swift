//
//  LabelTableViewCell.swift
//  Clock
//
//  Created by AaronH on 2020-06-10.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

class LabelTableViewCell: UITableViewCell {

    let txtLabel: UITextField = {
        let txtLabel = UITextField()
        txtLabel.translatesAutoresizingMaskIntoConstraints = false
        txtLabel.setValue(UIColor.white, forKeyPath: "textColor")
        txtLabel.backgroundColor = .modalViewBackground
        txtLabel.tintColor = .white
        return txtLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        contentView.addSubview(txtLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
