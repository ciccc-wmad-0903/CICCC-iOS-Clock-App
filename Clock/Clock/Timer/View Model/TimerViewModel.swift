//
//  TimerViewModel.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-10.
//  Copyright © 2020 CICCC. All rights reserved.
//

import RxSwift
import RxCocoa

protocol TimerViewModel: class {
    // Input
    var viewDidLoad: PublishRelay<Void> { get }
    
    // Output
}

final class TimerViewModelImpl: TimerViewModel {
    
    // MARK: - Input
    let viewDidLoad = PublishRelay<Void>()
    
    // MARK: - Output
    
    // MARK: - Private Properties(Reactive)
    private let coordinator: TimerCoordinator
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    init(coordinator: TimerCoordinator, timer: TimerModel) {
        self.coordinator = coordinator
        
        bindOnViewDidLoad()
    }
    
    // MARK: - Bindings
    private func bindOnViewDidLoad() {
        viewDidLoad
            .observeOn(MainScheduler.instance)
            .do(onNext: { print(#function) })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    // MARK: - Service Methods
}
