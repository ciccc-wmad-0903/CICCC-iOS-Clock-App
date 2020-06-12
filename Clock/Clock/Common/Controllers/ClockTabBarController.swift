//
//  ClockTabBarController.swift
//  Clock
//
//  Created by Kaden Kim on 2020-05-28.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

class ClockTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = UIColor.mainTintColor
        tabBar.barTintColor = .black
        
        let worldClockTVC = WorldClockTableViewController()
        worldClockTVC.tabBarItem = UITabBarItem(title: "World Clock", image: UIImage.init(systemName: "globe")?.withTintColor(UIColor.mainTintColor), tag: 0)
        let alarmTVC = AlarmTableViewController()
        alarmTVC.tabBarItem = UITabBarItem(title: "Alarm", image: UIImage.init(systemName: "alarm.fill")?.withTintColor(UIColor.mainTintColor), tag: 1)
        let stopwatchNC = UINavigationController()
        stopwatchNC.tabBarItem = UITabBarItem(title: "Stopwatch", image: UIImage.init(systemName: "stopwatch.fill")?.withTintColor(UIColor.mainTintColor), tag: 2)
        let timerNC = UINavigationController()
        timerNC.tabBarItem = UITabBarItem(title: "Timer", image: UIImage.init(systemName: "timer")?.withTintColor(UIColor.mainTintColor), tag: 3)
        
        viewControllers = [
            UINavigationController(rootViewController: worldClockTVC), UINavigationController(rootViewController: alarmTVC), stopwatchNC, timerNC ]
        
        worldClockTVC.view.backgroundColor = .black
        worldClockTVC.navigationController?.navigationBar.barTintColor = .black
        worldClockTVC.navigationController?.navigationBar.prefersLargeTitles = true
        worldClockTVC.navigationController?.navigationBar.titleTextAttributes = UIColor.whiteTextColorAttribution
        worldClockTVC.navigationController?.navigationBar.largeTitleTextAttributes = UIColor.whiteTextColorAttribution
        worldClockTVC.navigationItem.title = "World Clock"
        worldClockTVC.navigationItem.largeTitleDisplayMode = .always
        
        alarmTVC.view.backgroundColor = .black
        alarmTVC.navigationController?.navigationBar.barTintColor = .black
        alarmTVC.navigationController?.navigationBar.prefersLargeTitles = true
        alarmTVC.navigationController?.navigationBar.titleTextAttributes = UIColor.whiteTextColorAttribution
        alarmTVC.navigationController?.navigationBar.largeTitleTextAttributes = UIColor.whiteTextColorAttribution
        alarmTVC.navigationItem.title = "Alarm"
        alarmTVC.navigationItem.largeTitleDisplayMode = .always
        
        let stopwatchCoordinator = StopwatchCoordinatorImpl(navigationController: stopwatchNC)
        stopwatchCoordinator.start()
        
        let timerCoordinator = TimerCoordinatorImpl(navigationController: timerNC)
        timerCoordinator.start()
    }
    
}
