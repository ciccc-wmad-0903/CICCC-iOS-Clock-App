//
//  StopWatchViewController.swift
//  Clock
//
//  Created by Kaden Kim on 2020-05-28.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

import RxSwift

class StopwatchViewController: UIViewController {
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        bindOnButtons()
        bindOnDigitalStopwatch()
        bindOnAnalogStopwatch()
        bindOnTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear.accept(())
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear.accept(())
    }
    
    // MARK: - Properties
    var viewModel: StopwatchViewModel!
    private let disposeBag = DisposeBag()
    
    lazy var leftButton = CircleButton(title: "Lap", baseColor: .white, isEnabled: false)
    lazy var rightButton = CircleButton(title: "Start", baseColor: .systemRed)
    lazy var stopwatchScrollView = StopwatchScrollView()
    lazy var lapTableView = StopwatchTableView()
}

// MARK: - Binding
extension StopwatchViewController {
    
    private func bindOnButtons() {
        leftButton.rx.tap
            .bind(to: viewModel.didTapLeftButton)
            .disposed(by: disposeBag)
        
        rightButton.rx.tap
            .bind(to: viewModel.didTapRightButton)
            .disposed(by: disposeBag)
        
        viewModel.rightButtomStatus
            .drive(onNext: { color, title in
                DispatchQueue.main.async {
                    self.rightButton.baseColor = color
                    self.rightButton.setTitle(title, for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.leftButtonStatus
            .drive(onNext: { title, enabled in
                DispatchQueue.main.async {
                    self.leftButton.setTitle(title, for: .normal)
                    self.leftButton.isEnabled = enabled
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOnDigitalStopwatch() {
        viewModel.digitalCurrentText
            .drive(onNext: { text in
                DispatchQueue.main.async {
                    self.stopwatchScrollView.updateConstraintForDigitalStopwatch(text.count > 8)
                    self.view.layoutIfNeeded()
                    self.stopwatchScrollView.digitalStopwatchLabel.text = text
                    self.stopwatchScrollView.setDigitalStopwatchInAnalogLabelText(text)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOnAnalogStopwatch() {
        viewModel.analogCurrentDegree
            .drive(onNext: { radian in
                DispatchQueue.main.async { self.stopwatchScrollView.setMainHandAngle(radian) }
            })
            .disposed(by: disposeBag)
        
        viewModel.analogCurrentLapDegree
            .drive(onNext: { radian in
                DispatchQueue.main.async { self.stopwatchScrollView.setLapHandAngle(radian) }
            })
            .disposed(by: disposeBag)
        
        viewModel.analogCurrentSubDegree
            .drive(onNext: { radian in
                DispatchQueue.main.async { self.stopwatchScrollView.setSubHandAngle(radian) }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOnTableView() {
        viewModel.digitalCurrentLapText
            .drive(onNext: { text in
                DispatchQueue.main.async {
                    if let cell = self.lapTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? StopwatchLapsTableViewCell {
                        if let lapText = text {
                            cell.lapNumberLabel.text = "Lap \(self.lapTableView.laps.count + 1)"
                            cell.lapRecordLabel.text = lapText
                        } else {
                            cell.lapNumberLabel.text = ""
                            cell.lapRecordLabel.text = ""
                        }
                        cell.setTextColor()
                    }
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.updateLaps
            .drive(onNext: { laps in
                DispatchQueue.main.async {
                    self.lapTableView.laps = laps
                    self.lapTableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UI Setup
extension StopwatchViewController {
    
    private func setupUI() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .black
        
        setupUIPagingScrollView()
        setupUIButtons()
        setupUILapTableView()
    }
    
    private func setupUIPagingScrollView() {
        let pageControl = stopwatchScrollView.pageControl
        view.addSubview(stopwatchScrollView)
        view.addSubview(pageControl)
        stopwatchScrollView.anchors(topAnchor: view.safeAreaLayoutGuide.topAnchor,
                                    leadingAnchor: view.leadingAnchor,
                                    trailingAnchor: nil,
                                    bottomAnchor: nil,
                                    size: stopwatchScrollView.scrollViewSize)
        
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: stopwatchScrollView.bottomAnchor, constant: stopwatchScrollView.scrollViewSize.height * 0.055).isActive = true
    }
    
    private func setupUIButtons() {
        let buttonDiameter = CircleButton.buttonDiameter
        view.addSubview(leftButton)
        leftButton.anchors(topAnchor: nil,
                           leadingAnchor: view.leadingAnchor,
                           trailingAnchor: nil,
                           bottomAnchor: stopwatchScrollView.bottomAnchor,
                           padding: .init(top: 0, left: 16, bottom: -buttonDiameter / 2, right: 0),
                           size: .init(width: buttonDiameter, height: buttonDiameter))
        view.addSubview(rightButton)
        rightButton.anchors(topAnchor: nil,
                            leadingAnchor: nil,
                            trailingAnchor: view.trailingAnchor,
                            bottomAnchor: stopwatchScrollView.bottomAnchor,
                            padding: .init(top: 0, left: 0, bottom: -buttonDiameter / 2, right: 16),
                            size: .init(width: buttonDiameter, height: buttonDiameter))
    }
    
    private func setupUILapTableView() {
        view.addSubview(lapTableView)
        lapTableView.anchors(topAnchor: view.safeAreaLayoutGuide.topAnchor,
                             leadingAnchor: view.leadingAnchor,
                             trailingAnchor: view.trailingAnchor,
                             bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor,
                             padding: .init(top: UIDevice.current.safeAreaSize!.height * 0.565, left: 16, bottom: 0, right: 16))
    }
    
}
