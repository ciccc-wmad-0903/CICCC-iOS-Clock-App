//
//  TimerViewController.swift
//  Clock
//
//  Created by Kaden Kim on 2020-05-28.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

import RxSwift

let reloadTimerRemainingViewNotification = Notification.Name("TimerViewController.reloadRemainingView")

class TimerViewController: UIViewController {

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadRemainingView), name: reloadTimerRemainingViewNotification, object: nil)
        
        setupUI()
        
        bindOnButtons()
        bindOnRemainingView()
        bindOnSetTimer()
        bindOnSelectSound()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear.accept(())
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear.accept(())
    }
    
    @objc func reloadRemainingView() {
        viewModel.viewWillAppear.accept(())
    }
    
    // MARK: Properties
    var viewModel: TimerViewModel!
    private let disposeBag = DisposeBag()
    
    lazy var leftButton = CircleButton(title: "Cancel", baseColor: .white, isEnabled: false)
    lazy var rightButton = CircleButton(title: "Start", baseColor: .systemGreen)
    lazy var timerFadingView = TimerFadingView()
    lazy var timerSelectSoundTableView = TimerSelectSoundTableView()
}

// MARK: - Binding
extension TimerViewController {
    
    private func bindOnButtons() {
        leftButton.rx.tap
            .bind(to: viewModel.didTapLeftButton)
            .disposed(by: disposeBag)
        
        rightButton.rx.tap
            .bind(to: viewModel.didTapRightButton)
            .disposed(by: disposeBag)
        
        viewModel.leftButtonStatus
            .drive(onNext: { enabled in
                DispatchQueue.main.async {
                    self.leftButton.isEnabled = enabled
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.rightButtonStatus
            .drive(onNext: { color, title, enabled in
                DispatchQueue.main.async {
                    self.rightButton.baseColor = color
                    self.rightButton.setTitle(title, for: .normal)
                    self.rightButton.isEnabled = enabled
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOnRemainingView() {
        viewModel.isShownTimerPickerView
            .drive(onNext: {
                self.timerFadingView.setTimePicker.isHidden = !$0
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOnSetTimer() {
        viewModel.updateSetTimePicker
            .observeOn(MainScheduler.instance)
            .subscribeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { hour, minute, second in
                self.timerFadingView.setTimePicker.setTime(hour: hour, minute: minute, second: second)
            })
            .disposed(by: disposeBag)
        
        
    }
    
    private func bindOnSelectSound() {
        viewModel.setNameFromSoundID
            .drive(onNext: { name in
                DispatchQueue.main.async {
                    self.timerSelectSoundTableView.setSelectedSoundName(selectedSoundName: name)
                }
            })
            .disposed(by: disposeBag)
    }
    
}


// MARK: - UI Setup
extension TimerViewController {
    
    private func setupUI() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .black
        
        setupUIFadingView()
        setupUISelectSoundTableView()
        setupUIButtons()
    }
    
    private func setupUIFadingView() {
        view.addSubview(timerFadingView)
        timerFadingView.anchors(topAnchor: view.safeAreaLayoutGuide.topAnchor,
                           leadingAnchor: view.leadingAnchor,
                           trailingAnchor: nil,
                           bottomAnchor: nil,
                           size: timerFadingView.fadingViewSize)
    }
    
    private func setupUIButtons() {
        let buttonDiameter = CircleButton.buttonDiameter
        view.addSubview(leftButton)
        leftButton.anchors(topAnchor: nil,
                           leadingAnchor: view.leadingAnchor,
                           trailingAnchor: nil,
                           bottomAnchor: timerFadingView.bottomAnchor,
                           padding: .init(top: 0, left: 16, bottom: -buttonDiameter / 2, right: 0),
                           size: .init(width: buttonDiameter, height: buttonDiameter))
        view.addSubview(rightButton)
        rightButton.anchors(topAnchor: nil,
                            leadingAnchor: nil,
                            trailingAnchor: view.trailingAnchor,
                            bottomAnchor: timerFadingView.bottomAnchor,
                            padding: .init(top: 0, left: 0, bottom: -buttonDiameter / 2, right: 16),
                            size: .init(width: buttonDiameter, height: buttonDiameter))
    }
    
    private func setupUISelectSoundTableView() {
        timerSelectSoundTableView.delegate = self
        view.addSubview(timerSelectSoundTableView)
        timerSelectSoundTableView.anchors(topAnchor: view.safeAreaLayoutGuide.topAnchor,
                                          leadingAnchor: view.leadingAnchor,
                                          trailingAnchor: view.trailingAnchor,
                                          bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor,
                                          padding: .init(top: UIDevice.current.safeAreaSize!.height * 0.535, left: 0, bottom: 0, right: 0))
    }
    
}

// MARK: - TableView Delegate
extension TimerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.setTimerSound.accept(1005)
    }
}
