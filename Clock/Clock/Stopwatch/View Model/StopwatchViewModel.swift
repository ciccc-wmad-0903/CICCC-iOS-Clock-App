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
    
    // Output
    
}

final class StopwatchViewModelImpl: StopwatchViewModel {
    
    // MARK: - Input
    let viewDidLoad = PublishRelay<Void>()
    
    // MARK: - Output
    
    // MARK: - Private Properties
    private let coordinator: StopwatchCoordinator
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    init(coordinator: StopwatchCoordinator) {
        self.coordinator = coordinator
        bindOnViewDidLoad()
    }
    
    // MARK: - Bindings
    private func bindOnViewDidLoad() {
        viewDidLoad
            .observeOn(MainScheduler.instance)
            .do(onNext: { [unowned self] _ in
                self.loadStopwatchData()
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    // MARK: - Service Methods
    private func saveStopwatchData() {
        
    }
    
    private func loadStopwatchData() {
        
    }
}
