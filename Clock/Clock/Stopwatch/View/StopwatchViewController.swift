//
//  StopWatchViewController.swift
//  Clock
//
//  Created by Kaden Kim on 2020-05-28.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

import RxSwift

class StopwatchViewController: UIViewController {

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        viewModel.viewDidLoad.accept(())
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var viewModel: StopwatchViewModel!
}

// MARK: - UI Setup
extension StopwatchViewController {
    
    private func setupUI() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .black
        
    }
    
}
