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
    var viewWillAppear: PublishRelay<Void> { get }
    var viewDidDisappear: PublishRelay<Void> { get }
    var didTapLeftButton: PublishRelay<Void> { get }
    var didTapRightButton: PublishRelay<Void> { get }
    
    // Output
    var leftButtonStatus: Driver<(String, Bool)> { get }
    var rightButtomStatus: Driver<(UIColor, String)> { get }
    var digitalCurrentText: Driver<String> { get }
    var digitalCurrentLapText: Driver<String?> { get }
    var analogCurrentDegree: Driver<CGFloat> { get }
    var analogCurrentLapDegree: Driver<CGFloat> { get }
    var updateLaps: Driver<([Lap])> { get }
}

final class StopwatchViewModelImpl: StopwatchViewModel {
    
    // MARK: - Input
    let viewWillAppear = PublishRelay<Void>()
    let viewDidDisappear = PublishRelay<Void>()
    let didTapLeftButton = PublishRelay<Void>()
    let didTapRightButton = PublishRelay<Void>()
    
    // MARK: - Output
    let leftButtonStatus: Driver<(String, Bool)>
    let rightButtomStatus: Driver<(UIColor, String)>
    let digitalCurrentText: Driver<String>
    let digitalCurrentLapText: Driver<String?>
    let analogCurrentDegree: Driver<CGFloat>
    let analogCurrentLapDegree: Driver<CGFloat>
    let updateLaps: Driver<([Lap])>
    
    // MARK: - Private Properties(Reactive)
    private let coordinator: StopwatchCoordinator
    private let disposeBag = DisposeBag()
    private let globalScheduler = ConcurrentDispatchQueueScheduler.init(queue: DispatchQueue.global())
    private let uiScheduler = ConcurrentDispatchQueueScheduler.init(qos: .userInteractive)
    private var frameUpdateDisposable = SingleAssignmentDisposable()
    
    // MARK: - Private Properties(Stopwatch)
    private let stopwatchStatus = BehaviorRelay<StopwatchStatus>(value: .stop)
    private let stopwatchBase = BehaviorRelay<Date?>(value: nil)
    private let stopwatchPauseStart = BehaviorRelay<Date?>(value: nil)
    private let stopwatchLapStart = BehaviorRelay<Date?>(value: nil)
    private let stopwatchLaps = BehaviorRelay<[Lap]>(value: [])
    
    private let digitalCurrent = BehaviorRelay<TimeInterval>(value: 0)
    private let digitalCurrentLap = BehaviorRelay<TimeInterval?>(value: nil)
    
    private var stopwatchCurrent: TimeInterval { get { stopwatchBase.value?.distance(to: Date()) ?? 0 } }
    private var stopwatchLapCurrent: TimeInterval? { get { stopwatchLapStart.value?.distance(to: Date()) } }
    
    private let fps = 23.976
    private var minLap: (lap: TimeInterval, index: Int) = (0, -1)
    private var maxLap: (lap: TimeInterval, index: Int) = (0, -1)
    
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
        
        digitalCurrentText = digitalCurrent
            .map({ $0.toStopwatchString() })
            .asDriver(onErrorJustReturn: TimeInterval(0).toStopwatchString())
        
        digitalCurrentLapText = digitalCurrentLap
            .map({ $0?.toStopwatchString() ?? nil })
            .asDriver(onErrorJustReturn: TimeInterval(0).toStopwatchString())
        
        analogCurrentDegree = digitalCurrent
            .map({ CGFloat(Double.pi * 2 * $0.truncatingRemainder(dividingBy: 60) / 60) })
            .asDriver(onErrorJustReturn: CGFloat(0))
        
        analogCurrentLapDegree = digitalCurrentLap
            .map({ CGFloat(Double.pi * 2 * ($0?.truncatingRemainder(dividingBy: 60) ?? 0) / 60) })
            .asDriver(onErrorJustReturn: CGFloat(0))
        
        updateLaps = stopwatchLaps
            .asDriver(onErrorJustReturn: ([]))
        
        stopwatchStatus
            .observeOn(MainScheduler.asyncInstance)
            .do(onNext: { status in
                self.frameUpdater(isStart: status == .start)
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        stopwatchBase
            .do(onNext: { _ in self.digitalCurrent.accept(self.stopwatchCurrent) })
            .subscribe()
            .disposed(by: disposeBag)
        
        stopwatchLapStart
            .observeOn(MainScheduler.asyncInstance)
            .do(onNext: { laps in
                if laps == nil {
                    self.digitalCurrentLap.accept(self.stopwatchLapCurrent)
                    self.minLap = (0, -1)
                    self.maxLap = (0, -1)
                }
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        bindOnViewWillAppear()
        bindOnViewDidDisappear()
        bindOnDidTapLeftButton()
        bindOnDidTapRightButton()
    }
    
    // MARK: - Bindings
    
    private func bindOnViewWillAppear() {
        viewWillAppear
            .observeOn(MainScheduler.asyncInstance)
            .do(onNext: {
                if self.stopwatchStatus.value == .start {
                    self.frameUpdater(isStart: true)
                }
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func bindOnViewDidDisappear() {
        viewDidDisappear
            .observeOn(MainScheduler.asyncInstance)
            .do(onNext: { self.frameUpdater(isStart: false) })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func bindOnDidTapLeftButton() {
        didTapLeftButton
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: {
                switch self.stopwatchStatus.value {
                case .start: // To Check Lap
                    self.stopwatchLap()
                case .pause: // To Reset
                    self.stopwatchReset()
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
                case .start: // To Pause
                    self.stopwatchPause()
                case .pause: // To Restart
                    self.stopwatchRestart()
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
            var laps = stopwatchLaps.value
            laps.append(Lap(lap: lapStart.distance(to: current)))
            
            if laps.count == 2 {
                let gtFirst = laps[0].lap < laps[1].lap
                minLap = (laps[gtFirst ? 0 : 1].lap, gtFirst ? 0 : 1)
                maxLap = (laps[gtFirst ? 1 : 0].lap, gtFirst ? 1 : 0)
                laps[0].min = gtFirst
                laps[0].max = !gtFirst
                laps[1].min = !gtFirst
                laps[1].max = gtFirst
            } else if laps.count > 2 {
                let curIndex = laps.count - 1
                if laps[curIndex].lap < minLap.lap {
                    laps[minLap.index].min = false
                    laps[curIndex].min = true
                    minLap = (laps[curIndex].lap, curIndex)
                } else if maxLap.lap < laps[curIndex].lap {
                    laps[maxLap.index].max = false
                    laps[curIndex].max = true
                    maxLap = (laps[curIndex].lap, curIndex)
                }
            }
            stopwatchLaps.accept(laps)
        } else {
            stopwatchReset()
        }
    }
    
    private func frameUpdater(isStart: Bool) {
        frameUpdateDisposable.dispose()
        frameUpdateDisposable = SingleAssignmentDisposable()
        if isStart {
            let interval = Int(1000 / fps)
            let frameUpdater = Observable<Int>
                .interval(RxTimeInterval.milliseconds(interval), scheduler: uiScheduler)
                .map ({ _ in
                    self.digitalCurrent.accept(self.stopwatchCurrent)
                    self.digitalCurrentLap.accept(self.stopwatchLapCurrent)
                })
                .replayAll()
            frameUpdateDisposable.setDisposable(frameUpdater.connect())
        }
    }
}
