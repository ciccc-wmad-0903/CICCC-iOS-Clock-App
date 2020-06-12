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
        tmZnNm.font = .boldSystemFont(ofSize: 20)
        tmZnNm.textColor = .white
        tmZnNm.translatesAutoresizingMaskIntoConstraints = false
               
        return tmZnNm
    }()
  
    let timeLabel: UILabel = {
        let tmLb = UILabel()
        tmLb.font = tmLb.font.withSize(35)
        tmLb.textColor = .white
        tmLb.translatesAutoresizingMaskIntoConstraints = false
       
        return tmLb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style , reuseIdentifier: reuseIdentifier)
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(setTime), userInfo: nil, repeats: true)
       
        
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        let horStackView = HorizontalStackView(arrangedSubviews: [timeZoneName, timeLabel], spacing: 10 , distribution: .equalCentering )
        horStackView.isLayoutMarginsRelativeArrangement = true
        contentView.addSubview(horStackView)
        NSLayoutConstraint.activate([
            horStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            horStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            horStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            horStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -10)])
        
    }
//   MARK: - Getting timeLabel
    @objc func setTime() {
        timeLabel.text = getTime()
    }
    
    @objc func getTime() -> String {
        var timeString = ""
        if timeZoneName.text != "" {
           
            let formatter = DateFormatter()
            formatter.timeStyle = .short
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
