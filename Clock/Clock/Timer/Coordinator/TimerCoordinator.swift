//
//  TimerCoordinator.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-10.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

protocol TimerCoordinator: class {
    func saveTimer(timer: TimerModel)
    func loadTimer() -> TimerModel
    func pushToView(viewController: UIViewController)
}

class TimerCoordinatorImpl: Coordinator {
    
    unowned let navigationController: UINavigationController
    
    private var timer: TimerModel?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let timerViewController = TimerViewController()
        timerViewController.viewModel = TimerViewModelImpl(coordinator: self, timer: loadTimer())
        navigationController.pushViewController(timerViewController, animated: true)
    }
    
}

private let archiveFileName = "timer"
extension TimerCoordinatorImpl: TimerCoordinator {
    
    func pushToView(viewController: UIViewController) {
        navigationController.present(UINavigationController(rootViewController: viewController), animated: true, completion: nil)
    }
    
    func saveTimer(timer: TimerModel) {
        if self.timer != timer {
            self.timer = timer
            Persistence.saveData(data: timer, plistName: archiveFileName)
        }
    }
    
    func loadTimer() -> TimerModel {
        if let timer = Persistence.loadData(TimerModel.self, plistName: archiveFileName) {
            return timer
        } else {
            return TimerModel()
        }
    }
}
