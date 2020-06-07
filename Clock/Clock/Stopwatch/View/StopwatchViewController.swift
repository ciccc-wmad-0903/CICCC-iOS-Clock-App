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
    
    private var laps = [Lap]()
    
    lazy var leftButton = CircleButton(title: "Lap", baseColor: .white, isEnabled: false)
    lazy var rightButton = CircleButton(title: "Start", baseColor: .systemRed)
    lazy var stopwatchScrollView = StopwatchScrollView()
    
    lazy var lapTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .black
        tableView.separatorInset = .zero
        return tableView
    }()
    
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
                    self.stopwatchScrollView.digitalStopwatchInAnalogLabel.text = text
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOnTableView() {
        viewModel.digitalCurrentLapText
            .drive(onNext: { text in
                DispatchQueue.main.async {
                    if let cell = self.lapTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? StopwatchLapsTableViewCell {
                        if let lapText = text {
                            cell.lapNumberLabel.text = "Lap \(self.laps.count + 1)"
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
                    self.laps = laps
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
        stopwatchScrollView.anchors(topAnchor: view.safeAreaLayoutGuide.topAnchor, leadingAnchor: view.leadingAnchor,
                                    trailingAnchor: nil, bottomAnchor: nil, size: stopwatchScrollView.scrollViewSize)
        
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: stopwatchScrollView.bottomAnchor, constant: stopwatchScrollView.scrollViewSize.height * 0.055).isActive = true
    }
    
    private func setupUIButtons() {
        let buttonDiameter = CircleButton.buttonDiameter
        view.addSubview(leftButton)
        leftButton.anchors(topAnchor: nil, leadingAnchor: view.leadingAnchor, trailingAnchor: nil, bottomAnchor: stopwatchScrollView.bottomAnchor,
                           padding: .init(top: 0, left: 16, bottom: -buttonDiameter / 2, right: 0),
                           size: .init(width: buttonDiameter, height: buttonDiameter))
        view.addSubview(rightButton)
        rightButton.anchors(topAnchor: nil, leadingAnchor: nil, trailingAnchor: view.trailingAnchor, bottomAnchor: stopwatchScrollView.bottomAnchor,
                            padding: .init(top: 0, left: 0, bottom: -buttonDiameter / 2, right: 16),
                            size: .init(width: buttonDiameter, height: buttonDiameter))
    }
    
}

// MARK: - UI Setup: TableView
extension StopwatchViewController: UITableViewDataSource, UITableViewDelegate {
    
    private func setupUILapTableView() {
        view.addSubview(lapTableView)
        lapTableView.anchors(topAnchor: view.safeAreaLayoutGuide.topAnchor,
                             leadingAnchor: view.leadingAnchor,
                             trailingAnchor: view.trailingAnchor,
                             bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor,
                             padding: .init(top: UIDevice.current.safeAreaSize!.height * 0.565, left: 16, bottom: 0, right: 16))
        lapTableView.separatorColor = .tableViewSeparatorColor
        lapTableView.register(StopwatchLapsTableViewCell.self, forCellReuseIdentifier: StopwatchLapsTableViewCell.reuseIdentifier)
        lapTableView.dataSource = self
        lapTableView.delegate = self
        
        let line = UIView(frame: CGRect(x: 20, y: 0, width: lapTableView.frame.size.width - 36, height: 1 / UIScreen.main.scale))
        line.backgroundColor = .tableViewSeparatorColor
        lapTableView.tableHeaderView = line
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 7.3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : laps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StopwatchLapsTableViewCell.reuseIdentifier, for: indexPath) as! StopwatchLapsTableViewCell
        if indexPath.section == 1 {
            let data = laps[laps.count - indexPath.row - 1]
            cell.lapNumberLabel.text = "Lap \(laps.count - indexPath.row)"
            cell.lapRecordLabel.text = data.lapString
            cell.setTextColor(min: data.min, max: data.max, normal: !(data.min || data.max))
        }
        return cell
    }
    
}
