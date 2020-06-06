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

        viewModel.viewDidLoad.accept(())
        
        bindOnButtons()
        bindOnDigitalStopwatch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear.accept(())
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(#function)
    }
    
    // MARK: - Properties
    var viewModel: StopwatchViewModel!
    private let disposeBag = DisposeBag()
    
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()

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
            .drive(onNext: {
                self.rightButton.baseColor = $0
                self.rightButton.setTitle($1, for: .normal)
            })
            .disposed(by: disposeBag)
        
        viewModel.leftButtonStatus
            .drive(onNext: {
                self.leftButton.setTitle($0, for: .normal)
                self.leftButton.isEnabled = $1
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOnDigitalStopwatch() {
        viewModel.digitalCurrentText
            .drive(onNext: {
                self.updateConstraintForDigitalStopwatch($0.count > 8)
                self.view.layoutIfNeeded()
                self.digitalStopwatchLabel.text = $0
                self.digitalStopwatchInAnalogLabel.text = $0
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
    
    private func setupUILapTableView() {
        view.addSubview(lapTableView)
        lapTableView.anchors(topAnchor: view.safeAreaLayoutGuide.topAnchor,
                             leadingAnchor: view.leadingAnchor,
                             trailingAnchor: view.trailingAnchor,
                             bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor,
                             padding: .init(top: UIDevice.current.safeAreaSize!.height * 0.565, left: 0, bottom: 0, right: 0))
        lapTableView.separatorColor = .tableViewSeparatorColor
    }
    
}

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
