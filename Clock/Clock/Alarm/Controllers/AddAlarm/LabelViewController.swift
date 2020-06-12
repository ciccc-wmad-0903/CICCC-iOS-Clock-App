//
//  LabelTableViewController.swift
//  Clock
//
//  Created by AaronH on 2020-06-10.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

class LabelViewController: UIViewController, UITextFieldDelegate {
    
    
    var txtLabel: UITextField = {
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 5.0))
        let rightButton = UIButton(type: .close)

        let txtLabel = UITextField()
        txtLabel.translatesAutoresizingMaskIntoConstraints = false
        txtLabel.setValue(UIColor.white, forKeyPath: "textColor")
        txtLabel.backgroundColor = .rightDetailCellBackgroundColor
        txtLabel.text = "Alarm"
        txtLabel.font = UIFont.init(name: "", size: 20.0)
        txtLabel.textColor = .white
        txtLabel.tintColor = .mainTintColor
        txtLabel.leftView = leftView
        txtLabel.leftViewMode = .always
        txtLabel.rightView = rightButton
        txtLabel.rightViewMode = .always
        return txtLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .modalViewBackground
        title = "Label"
        navigationController?.navigationBar.barTintColor = .rightDetailCellBackgroundColor
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.titleTextAttributes = UIColor.whiteTextColorAttribution
        navigationController?.navigationBar.tintColor = .mainTintColor
        
        txtLabel.delegate = self
        txtLabel.becomeFirstResponder()
        view.addSubview(txtLabel)
        
        NSLayoutConstraint.activate([
            txtLabel.heightAnchor.constraint(equalToConstant: 50),
            txtLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            txtLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            txtLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          txtLabel.becomeFirstResponder()
          return true
    }
}
