//
//  StopWatchCoordinator.swift
//  Clock
//
//  Created by Kaden Kim on 2020-05-31.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

protocol StopwatchCoordinator: class {}

class StopwatchCoordinatorImpl: Coordinator {
    
    unowned let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let stopwatchViewController = StopwatchViewController()
        let stopwatchViewModel = StopwatchViewModelImpl(coordinator: self)
        stopwatchViewController.viewModel = stopwatchViewModel
        navigationController.pushViewController(stopwatchViewController, animated: true)
    }
    
}

extension StopwatchCoordinatorImpl: StopwatchCoordinator {}
