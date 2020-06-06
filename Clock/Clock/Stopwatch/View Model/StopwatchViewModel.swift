//
//  StopwatchViewModel.swift
//  Clock
//
//  Created by Kaden Kim on 2020-05-31.
//  Copyright © 2020 CICCC. All rights reserved.
//

import RxSwift
import RxCocoa

protocol StopwatchViewModel: class {
    // Input
    var viewDidLoad: PublishRelay<Void> { get }
    var viewWillAppear: PublishRelay<Void> { get }
    var viewDidDisappear: PublishRelay<Void> { get }
    var didTapLeftButton: PublishRelay<Void> { get }
    var didTapRightButton: PublishRelay<Void> { get }
    
    // Output
    var leftButtonStatus: Driver<(String, Bool)> { get }
    var rightButtomStatus: Driver<(UIColor, String)> { get }
    
}

final class StopwatchViewModelImpl: StopwatchViewModel {
    
    // MARK: - Input
    let viewDidLoad = PublishRelay<Void>()
    let viewWillAppear = PublishRelay<Void>()
    let viewDidDisappear = PublishRelay<Void>()
    let didTapLeftButton = PublishRelay<Void>()
    let didTapRightButton = PublishRelay<Void>()
    
    // MARK: - Output
    let leftButtonStatus: Driver<(String, Bool)>
    let rightButtomStatus: Driver<(UIColor, String)>
    
    // MARK: - Private Properties(Reactive)
    private let coordinator: StopwatchCoordinator
    private let disposeBag = DisposeBag()
    
    // MARK: - Private Properties(Stopwatch)
    private let stopwatchStatus = BehaviorRelay<StopwatchStatus>(value: .stop)
    private let stopwatchBase = BehaviorRelay<Date?>(value: nil)
    private let stopwatchPauseStart = BehaviorRelay<Date?>(value: nil)
    private let stopwatchLapStart = BehaviorRelay<Date?>(value: nil)
    private let stopwatchLaps = BehaviorRelay<[TimeInterval]>(value: [])
    
    private var stopwatchCurrent: TimeInterval {
        get { stopwatchBase.value?.distance(to: Date()) ?? 0 }
    }
    private var stopwatchLapCurrent: TimeInterval {
        get { stopwatchLapStart.value?.distance(to: Date()) ?? 0 }
    }
    
    // MARK: - Initialization
    init(stopwatch: Stopwatch, coordinator: StopwatchCoordinator) {
        self.coordinator = coordinator
        
        leftButtonStatus = stopwatchStatus
            .map({ stopwatchStatus in
                switch stopwatchStatus {
                case .stop: return ("Lap", false)
                case .start: return ("Lap", true)
                case .pause: return ("Reset", true)
                }
            })
            .asDriver(onErrorJustReturn: ("Lap", false))

        rightButtomStatus = stopwatchStatus
            .map({ stopwatchStatus in
                switch stopwatchStatus {
                case .stop, .pause: return (UIColor.systemGreen, "Start")
                case .start: return (UIColor.systemRed, "Stop")
                }
            })
            .asDriver(onErrorJustReturn: (UIColor.systemGreen, "Start"))
        
        bindOnViewDidLoad()
        bindOnViewWillAppear()
        bindOnViewDidDisappear()
        bindOnDidTapLeftButton()
        bindOnDidTapRightButton()
    }
    
    // MARK: - Bindings
    private func bindOnViewDidLoad() {
        viewDidLoad
            .observeOn(MainScheduler.instance)
            .do(onNext: { print(#function) })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func bindOnViewWillAppear() {
        viewWillAppear
            .observeOn(MainScheduler.instance)
            .do(onNext: { print(#function) })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func bindOnViewDidDisappear() {
        viewDidDisappear
            .observeOn(MainScheduler.instance)
            .do(onNext: { print(#function) })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func bindOnDidTapLeftButton() {
        didTapLeftButton
            .subscribe(onNext: {
                switch self.stopwatchStatus.value {
                case .start: // To Check Lap
                    self.stopwatchLap()
                    print("Check Lap!")
                case .pause: // To Reset
                    self.stopwatchReset()
                    print("Reset!")
                case .stop: // Disabled: Never execute!
                    assertionFailure("Shouldn't be here")
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOnDidTapRightButton() {
        didTapRightButton
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {
                switch self.stopwatchStatus.value {
                case .stop: // To Start
                    self.stopwatchStart()
                    print("Start!")
                case .start: // To Pause
                    self.stopwatchPause()
                    print("Pause!")
                case .pause: // To Restart
                    self.stopwatchRestart()
                    print("Restart!")
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Service Methods
    private func stopwatchReset() {
        stopwatchBase.accept(nil)
        stopwatchPauseStart.accept(nil)
        stopwatchLapStart.accept(nil)
        stopwatchLaps.accept([])
        stopwatchStatus.accept(.stop)
    }
    
    private func stopwatchStart() {
        stopwatchBase.accept(Date())
        stopwatchLapStart.accept(stopwatchBase.value)
        stopwatchStatus.accept(.start)
    }
    
    private func stopwatchRestart() {
        if let base = stopwatchBase.value, let lap = stopwatchLapStart.value, let pauseStart = stopwatchPauseStart.value {
            let interval = pauseStart.distance(to: Date())
            stopwatchBase.accept(base.addingTimeInterval(interval))
            stopwatchLapStart.accept(lap.addingTimeInterval(interval))
            stopwatchPauseStart.accept(nil)
            stopwatchStatus.accept(.start)
        } else {
            stopwatchReset()
        }
    }
    
    private func stopwatchPause() {
        if stopwatchStatus.value == .start, stopwatchPauseStart.value == nil {
            stopwatchPauseStart.accept(Date())
            stopwatchStatus.accept(.pause)
        } else {
            stopwatchReset()
        }
    }
    
    private func stopwatchLap() {
        if stopwatchStatus.value == .start, let lapStart = stopwatchLapStart.value {
            let current = Date()
            stopwatchLapStart.accept(current)
            var prevLaps = stopwatchLaps.value
            prevLaps.append(lapStart.distance(to: current))
            stopwatchLaps.accept(prevLaps)
        } else {
            stopwatchReset()
        }
    }
}
