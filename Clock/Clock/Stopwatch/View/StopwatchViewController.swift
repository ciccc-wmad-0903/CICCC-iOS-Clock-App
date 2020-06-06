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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear.accept(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear.accept(())
    }
    
    // MARK: - Properties
    var viewModel: StopwatchViewModel!
    private let disposeBag = DisposeBag()
    
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    
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
    
    lazy var leftButton = CircleButton(title: "Lap", baseColor: .white, isEnabled: true)
    lazy var rightButton = CircleButton(title: "Start", baseColor: .systemRed)
    
}

// MARK: - Binding
extension StopwatchViewController {
    
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
        let buttonsView = UIView()
        view.addSubview(buttonsView)
        buttonsView.constraintHeight(equalToConstant: buttonDiameter)
        buttonsView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: buttonDiameter / 2).isActive = true
        buttonsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        buttonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        buttonsView.addSubview(leftButton)
        leftButton.anchors(topAnchor: buttonsView.topAnchor, leadingAnchor: buttonsView.leadingAnchor, trailingAnchor: nil, bottomAnchor: nil,
                           size: .init(width: buttonDiameter, height: buttonDiameter))
        buttonsView.addSubview(rightButton)
        rightButton.anchors(topAnchor: buttonsView.topAnchor, leadingAnchor: nil, trailingAnchor: buttonsView.trailingAnchor, bottomAnchor: nil,
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
        digitalStopwatchLabel.leadingAnchor.constraint(equalTo: digitalView.leadingAnchor, constant: 12).isActive = true
        digitalStopwatchLabel.trailingAnchor.constraint(equalTo: digitalView.trailingAnchor, constant: -12).isActive = true
        
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
    
}
