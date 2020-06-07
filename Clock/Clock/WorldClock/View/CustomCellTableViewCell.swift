//
//  CustomCellTableViewCell.swift
//  Clock
//
//  Created by Mac on 2020-06-05.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

class CustomCellTableViewCell: UITableViewCell {
    
    let timeZoneName: UILabel = {
       let tmZnNm = UILabel()
        tmZnNm.translatesAutoresizingMaskIntoConstraints = false
               
        return tmZnNm
    }()
  
    let timeLabel: UILabel = {
        let tmLb = UILabel()
        tmLb.translatesAutoresizingMaskIntoConstraints = false
       
        return tmLb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style , reuseIdentifier: reuseIdentifier)
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(setTime), userInfo: nil, repeats: true)
       
        setupConstraints()
    }
    private func setupConstraints() {
        
        let verStackView = VerticalStackView(arrangedSubviews: [timeZoneName, timeLabel], spacing: 10 ,distribution: .fillEqually )
        contentView.addSubview(verStackView)
        NSLayoutConstraint.activate([
            verStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            verStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            verStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            verStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)])
        
    }
//   MARK: - Getting timeLabel
    @objc func setTime() {
        timeLabel.text = getTime()
    }
    
    @objc func getTime() -> String {
        var timeString = ""
        if timeZoneName.text != "" {
           
            let formatter = DateFormatter()
            formatter.timeStyle = .long
            formatter.timeZone = TimeZone(identifier: timeZoneName.text!)
            
            let timeNow = Date()
            timeString = formatter.string(from: timeNow)
         
        }
        
        return timeString
    }
    
//    required init 
    required init?(coder: NSCoder) {
        fatalError()
    }
}
