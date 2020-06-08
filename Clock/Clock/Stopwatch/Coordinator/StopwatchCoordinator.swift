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
    
    private let archiveURL: URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("stopwatch").appendingPathExtension("plist")
    }()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let stopwatchViewController = StopwatchViewController()
        stopwatchViewController.viewModel = StopwatchViewModelImpl(coordinator: self, stopwatch: loadStopwatch())
        navigationController.pushViewController(stopwatchViewController, animated: true)
    }
    
}

extension StopwatchCoordinatorImpl: StopwatchCoordinator {
    
    func saveStopwatch(stopwatch: Stopwatch) {
        if self.stopwatch != stopwatch {
            self.stopwatch = stopwatch
            if let encodedStopwatch = try? PropertyListEncoder().encode(stopwatch) {
                try? encodedStopwatch.write(to: archiveURL, options: .noFileProtection)
            }
        }
    }
    
    func loadStopwatch() -> Stopwatch {
        if let retrievedStopwatchData = try? Data(contentsOf: archiveURL), let decodedStopwatch = try? PropertyListDecoder().decode(Stopwatch.self, from: retrievedStopwatchData) {
            return decodedStopwatch
        } else {
            return Stopwatch()
        }
    }
    
}
