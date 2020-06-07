//
//  StopwatchScrollViewController.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-06.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

class StopwatchScrollView: UIScrollView, UIScrollViewDelegate {
    
    private(set) var scrollViewSize: CGSize!
    
    private let numberOfPages = 2
    
    lazy var pageControl = UIPageControl()
    lazy var digitalStopwatchLabel = StopwatchDigitalLabel()
    lazy var digitalStopwatchInAnalogLabel = StopwatchDigitalLabel()
    
    private var digitalStopwatchLabelLeadingConstraintWith4: NSLayoutConstraint?
    private var digitalStopwatchLabelLeadingConstraintWith12: NSLayoutConstraint?
    private var digitalStopwatchLabelTrailingConstraintWith4: NSLayoutConstraint?
    private var digitalStopwatchLabelTrailingConstraintWith12: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let safeAreaSize = UIDevice.current.safeAreaSize!
        scrollViewSize = CGSize(width: safeAreaSize.width, height: safeAreaSize.height * 0.491)
        
        translatesAutoresizingMaskIntoConstraints = false
        showsHorizontalScrollIndicator = false
        isPagingEnabled = true
        delegate = self
        
        let pagesStackView = HorizontalStackView(arrangedSubviews: [], distribution: .equalSpacing)
        addSubview(pagesStackView)
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
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .pageIndicatorColor
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.addTarget(self, action: #selector(pageControlTapped(sender:)), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateConstraintForDigitalStopwatch(_ moreThan8Chars: Bool) {
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.bounds.width != 0 {
            pageControl.currentPage = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        }
    }
    
    @objc private func pageControlTapped(sender: UIPageControl) {
        UIView.animate(withDuration: 0.33) { [weak self] in
            guard let self = self else { return }
            self.contentOffset.x = CGFloat(sender.currentPage * Int(self.bounds.width))
        }
    }
    
}
