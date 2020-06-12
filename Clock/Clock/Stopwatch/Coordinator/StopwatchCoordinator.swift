//
//  StopWatchCoordinator.swift
//  Clock
//
//  Created by Kaden Kim on 2020-05-31.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

protocol StopwatchCoordinator: class {
    func saveStopwatch(stopwatch: Stopwatch)
    func loadStopwatch() -> Stopwatch
}

class StopwatchCoordinatorImpl: Coordinator {
    
    unowned let navigationController: UINavigationController
    
    private var stopwatch: Stopwatch?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let stopwatchViewController = StopwatchViewController()
        stopwatchViewController.viewModel = StopwatchViewModelImpl(coordinator: self, stopwatch: loadStopwatch())
        navigationController.pushViewController(stopwatchViewController, animated: true)
    }
    
}

private let archiveFileName = "stopwatch"
extension StopwatchCoordinatorImpl: StopwatchCoordinator {
    
    func saveStopwatch(stopwatch: Stopwatch) {
        if self.stopwatch != stopwatch {
            self.stopwatch = stopwatch
            Persistence.saveData(data: stopwatch, plistName: archiveFileName)
        }
    }
    
    func loadStopwatch() -> Stopwatch {
        if let stopwatch = Persistence.loadData(Stopwatch.self, plistName: archiveFileName) {
            return stopwatch
        } else {
            return Stopwatch()
        }
    }
    
}
