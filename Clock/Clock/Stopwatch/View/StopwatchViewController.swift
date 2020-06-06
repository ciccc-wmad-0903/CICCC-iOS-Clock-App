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
    
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    
    private var laps = [String]()
    
    private var digitalStopwatchLabelLeadingConstraintWith4: NSLayoutConstraint?
    private var digitalStopwatchLabelLeadingConstraintWith12: NSLayoutConstraint?
    private var digitalStopwatchLabelTrailingConstraintWith4: NSLayoutConstraint?
    private var digitalStopwatchLabelTrailingConstraintWith12: NSLayoutConstraint?
    
    lazy var digitalStopwatchLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00.00"
        label.textColor = .white
        label.font = .monospacedDigitSystemFont(ofSize: 100, weight: .thin)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.allowsDefaultTighteningForTruncation = false
        label.minimumScaleFactor = 0.1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var digitalStopwatchInAnalogLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00.00"
        label.textColor = .white
        label.font = .monospacedDigitSystemFont(ofSize: 100, weight: .regular)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.allowsDefaultTighteningForTruncation = false
        label.minimumScaleFactor = 0.1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var lapTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .black
        tableView.separatorInset = .zero
        return tableView
    }()
    
    lazy var leftButton = CircleButton(title: "Lap", baseColor: .white, isEnabled: false)
    lazy var rightButton = CircleButton(title: "Start", baseColor: .systemRed)
    
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
                    self.updateConstraintForDigitalStopwatch(text.count > 8)
                    self.view.layoutIfNeeded()
                    self.digitalStopwatchLabel.text = text
                    self.digitalStopwatchInAnalogLabel.text = text
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
    
    private func setupUIButtons() {
        let buttonDiameter = CircleButton.buttonDiameter
        view.addSubview(leftButton)
        leftButton.anchors(topAnchor: nil, leadingAnchor: view.leadingAnchor, trailingAnchor: nil, bottomAnchor: scrollView.bottomAnchor,
                           padding: .init(top: 0, left: 16, bottom: -buttonDiameter / 2, right: 0),
                           size: .init(width: buttonDiameter, height: buttonDiameter))
        view.addSubview(rightButton)
        rightButton.anchors(topAnchor: nil, leadingAnchor: nil, trailingAnchor: view.trailingAnchor, bottomAnchor: scrollView.bottomAnchor,
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
            cell.lapNumberLabel.text = "Lap \(laps.count - indexPath.row)"
            cell.lapRecordLabel.text = laps[indexPath.row]
        }
        return cell
    }
}

// MARK: - UI Setup: Paging ScrollView
extension StopwatchViewController: UIScrollViewDelegate {
    
    /// Add Page-enabled ScrollView
    private func setupUIPagingScrollView() {
        let safeAreaSize = UIDevice.current.safeAreaSize!
        let scrollViewSize = CGSize(width: safeAreaSize.width, height: safeAreaSize.height * 0.491)
        let numberOfPages = 2
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        view.addSubview(scrollView)
        scrollView.anchors(topAnchor: view.safeAreaLayoutGuide.topAnchor, leadingAnchor: view.leadingAnchor,
                           trailingAnchor: nil, bottomAnchor: nil, size: scrollViewSize)
        
        let pagesStackView = HorizontalStackView(arrangedSubviews: [], distribution: .equalSpacing)
        scrollView.addSubview(pagesStackView)
        pagesStackView.matchParent()
        
        let digitalView = UIView()
        digitalView.translatesAutoresizingMaskIntoConstraints = false
        pagesStackView.addArrangedSubview(digitalView)
        digitalView.constraintWidth(equalToConstant: scrollViewSize.width, heightEqualToConstant: scrollViewSize.height)
        
        digitalView.addSubview(digitalStopwatchLabel)
        digitalStopwatchLabel.centerYAnchor.constraint(equalTo: digitalView.centerYAnchor).isActive = true
        digitalStopwatchLabelLeadingConstraintWith4 = digitalStopwatchLabel.leadingAnchor.constraint(equalTo: digitalView.leadingAnchor, constant: 4)
        digitalStopwatchLabelLeadingConstraintWith12 = digitalStopwatchLabel.leadingAnchor.constraint(equalTo: digitalView.leadingAnchor, constant: 12)
        digitalStopwatchLabelTrailingConstraintWith4 = digitalStopwatchLabel.trailingAnchor.constraint(equalTo: digitalView.trailingAnchor, constant: -4)
        digitalStopwatchLabelTrailingConstraintWith12 = digitalStopwatchLabel.trailingAnchor.constraint(equalTo: digitalView.trailingAnchor, constant: -12)
        digitalStopwatchLabelLeadingConstraintWith12?.isActive = true
        digitalStopwatchLabelTrailingConstraintWith12?.isActive = true
        
        let analogView = UIView()
        analogView.translatesAutoresizingMaskIntoConstraints = false
        pagesStackView.addArrangedSubview(analogView)
        analogView.constraintWidth(equalToConstant: scrollViewSize.width, heightEqualToConstant: scrollViewSize.height)
        
        analogView.addSubview(digitalStopwatchInAnalogLabel)
        digitalStopwatchInAnalogLabel.bottomAnchor.constraint(equalTo: analogView.bottomAnchor, constant: -scrollViewSize.height * 0.25).isActive = true
        digitalStopwatchInAnalogLabel.leadingAnchor.constraint(equalTo: analogView.leadingAnchor, constant: scrollViewSize.width * 0.375).isActive = true
        digitalStopwatchInAnalogLabel.trailingAnchor.constraint(equalTo: analogView.trailingAnchor, constant: -scrollViewSize.width * 0.375).isActive = true
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
        pageControl.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: scrollViewSize.height * 0.055).isActive = true
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .pageIndicatorColor
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.addTarget(self, action: #selector(pageControlTapped(sender:)), for: .valueChanged)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.bounds.width != 0 {
            pageControl.currentPage = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        }
    }
    
    @objc private func pageControlTapped(sender: UIPageControl) {
        UIView.animate(withDuration: 0.33) { [weak self] in
            guard let self = self else { return }
            self.scrollView.contentOffset.x = CGFloat(sender.currentPage * Int(self.scrollView.bounds.width))
        }
    }
    
    private func updateConstraintForDigitalStopwatch(_ moreThan8Chars: Bool) {
        if moreThan8Chars {
            self.digitalStopwatchLabelLeadingConstraintWith12?.isActive = false
            self.digitalStopwatchLabelTrailingConstraintWith12?.isActive = false
            self.digitalStopwatchLabelLeadingConstraintWith4?.isActive = true
            self.digitalStopwatchLabelTrailingConstraintWith4?.isActive = true
        } else {
            self.digitalStopwatchLabelLeadingConstraintWith4?.isActive = false
            self.digitalStopwatchLabelTrailingConstraintWith4?.isActive = false
            self.digitalStopwatchLabelLeadingConstraintWith12?.isActive = true
            self.digitalStopwatchLabelTrailingConstraintWith12?.isActive = true
        }
    }
    
}
