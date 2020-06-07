//
//  StopWatchCoordinator.swift
//  Clock
//
//  Created by Kaden Kim on 2020-05-31.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

let saveStopwatchNotification = Notification.Name("StopwatchCoordinator.saveStopwatch")

protocol StopwatchCoordinator: class {
    func saveStopwatch()
    func loadStopwatch() -> Stopwatch
    func cacheStopwatch(stopwatch: Stopwatch)
}

class StopwatchCoordinatorImpl: Coordinator {
    
    unowned let navigationController: UINavigationController
    
    private var stopwatch: Stopwatch!
    
    private let archiveURL: URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("stopwatch").appendingPathExtension("plist")
    }()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        stopwatch = loadStopwatch()
        NotificationCenter.default.addObserver(self, selector: #selector(saveStopwatch), name: saveStopwatchNotification, object: nil)
    }
    
    func start() {
        let stopwatchViewController = StopwatchViewController()
        let stopwatchViewModel = StopwatchViewModelImpl(stopwatch: stopwatch, coordinator: self)
        stopwatchViewController.viewModel = stopwatchViewModel
        navigationController.pushViewController(stopwatchViewController, animated: true)
    }
    
}

extension StopwatchCoordinatorImpl: StopwatchCoordinator {
    
    @objc func saveStopwatch() {
        if let encodedStopwatch = try? PropertyListEncoder().encode(stopwatch) {
            try? encodedStopwatch.write(to: archiveURL, options: .noFileProtection)
        }
    }
    
    func loadStopwatch() -> Stopwatch {
        if let retrievedStopwatchData = try? Data(contentsOf: archiveURL), let decodedStopwatch = try? PropertyListDecoder().decode(Stopwatch.self, from: retrievedStopwatchData) {
                return decodedStopwatch
        } else {
            return Stopwatch()
        }
    }
    
    func cacheStopwatch(stopwatch: Stopwatch) {
        self.stopwatch = stopwatch
    }
    
}
