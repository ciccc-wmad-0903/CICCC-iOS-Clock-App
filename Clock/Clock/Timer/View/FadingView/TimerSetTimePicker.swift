//
//  TimerSetTimePicker.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-11.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

class TimerSetTimePicker: UIPickerView {
    
    private(set) var setTimePickerSize: CGSize!
    
    var pickerDelegate: TimerSetPickerDelegate?
    
    private lazy var hourLabel: UILabel = {
        let label = UILabel(frame: .init(x: 0, y: 0, width: setTimePickerSize.width / 7, height: setTimePickerSize.height / 8.5))
        label.text = (self.hour == 1) ? "hour" : "hours"
        return label
    }()
    
    private lazy var timeLabelSize: CGSize = .init(width: self.setTimePickerSize.width / 7, height: self.setTimePickerSize.height / 8.5)
    
    private lazy var makeTimeLabel: () -> UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }
    
    private var hour = 0
    private var minute = 10
    private var second = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let safeAreaSize = UIDevice.current.safeAreaSize!
        setTimePickerSize = CGSize(width: safeAreaSize.width, height: safeAreaSize.height / 3)
        
        setupViewProperties()
        setupTimeLabels()
        
        setTime(hour: hour, minute: minute, second: second)
    }
    
    func setTime(hour: Int, minute: Int, second: Int) {
        selectRow(hour, inComponent: 0, animated: false)
        selectRow(minute, inComponent: 1, animated: false)
        selectRow(second, inComponent: 2, animated: false)
    }
    
    private func setupViewProperties() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        dataSource = self
        delegate = self
    }
    
    private func setupTimeLabels() {
        hourLabel = makeTimeLabel()
        hourLabel.text = (self.hour == 1) ? "hour" : "hours"
        
        let minLabel = makeTimeLabel()
        minLabel.text = "min"
        
        let secLabel = makeTimeLabel()
        secLabel.text = "sec"
        
        let stackView = HorizontalStackView(arrangedSubviews: [
            hourLabel, minLabel, secLabel
        ], spacing: 5, distribution: .fillEqually)
        addSubview(stackView)
        stackView.matchParent(padding: .init(top: 0, left: frame.size.width / 5.5, bottom: 0, right: -frame.size.width / 5.5))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TimerSetTimePicker: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? 24 : 60
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        subviews[subviews.count - 1].backgroundColor = .tableViewSeparatorColor
        subviews[subviews.count - 2].backgroundColor = .tableViewSeparatorColor
        
        let numberLabel = UILabel()
        numberLabel.backgroundColor = .clear
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.text = "\(row)"
        numberLabel.textColor = .white
        numberLabel.font = .systemFont(ofSize: 23, weight: .medium)
        numberLabel.textAlignment = .right
        
        let view = view ?? UIView()
        view.backgroundColor = .clear
        view.addSubview(numberLabel)
        numberLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -frame.size.width / 100).isActive = true
        return view
    }
    
}

extension TimerSetTimePicker: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        hourLabel.text = component == 0 && row == 1 ? "hour" : "hours"
        switch component {
        case 0: hour = row
        case 1: minute = row
        case 2: second = row
        default: break
        }
        pickerDelegate?.timerSetTime(hour: hour, minute: minute, second: second)
    }
    
}
