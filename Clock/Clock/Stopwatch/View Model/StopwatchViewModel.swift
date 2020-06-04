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
    var didTouchLeftButton: PublishRelay<Void> { get }
    var didTouchRightButton: PublishRelay<Void> { get }
    
    // Output
    
}

final class StopwatchViewModelImpl: StopwatchViewModel {
    
    // MARK: - Input
    let viewDidLoad = PublishRelay<Void>()
    let didTouchLeftButton = PublishRelay<Void>()
    let didTouchRightButton = PublishRelay<Void>()
    
    // MARK: - Output
    
    // MARK: - Private Properties
    private var stopwatch: Stopwatch
    private let coordinator: StopwatchCoordinator
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    init(stopwatch: Stopwatch, coordinator: StopwatchCoordinator) {
        self.stopwatch = stopwatch
        self.coordinator = coordinator
        bindOnViewDidLoad()
    }
    
    // MARK: - Bindings
    private func bindOnViewDidLoad() {
        viewDidLoad
            .observeOn(MainScheduler.instance)
//            .do(onNext: { [unowned self] _ in })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    // MARK: - Service Methods
}
