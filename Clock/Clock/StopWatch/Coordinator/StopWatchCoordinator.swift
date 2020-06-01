//
//  StopWatchCoordinator.swift
//  Clock
//
//  Created by Kaden Kim on 2020-05-31.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

protocol StopWatchCoordinator: class {}

class StopWatchCoordinatorImpl: Coordinator {
    
    unowned let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func start() {}
}

extension StopWatchCoordinatorImpl: StopWatchCoordinator {}
