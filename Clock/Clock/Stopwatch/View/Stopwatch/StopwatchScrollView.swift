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
    
    lazy var digitalStopwatchLabel: StopwatchDigitalLabel? = nil
    lazy var analogClockView: AnalogClockView? = nil
    lazy var pagesStackView: UIStackView? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let safeAreaSize = UIDevice.current.safeAreaSize!
        scrollViewSize = CGSize(width: safeAreaSize.width, height: safeAreaSize.height * 0.491)
        
        setupScrollViewProperties()
        setupPagesStackView(setupDigitalViewPage(), setupAnalogViewPage())
        setupPageControl()
    }
    
    func setDigitalStopwatchInAnalogLabelText(_ stopwatchText: String) {
        analogClockView?.digitalStopwatchInAnalogLabel.text = stopwatchText
    }
    
    func setMainHandAngle(_ radian: CGFloat) {
        CALayer.performWithoutAnimation {
            analogClockView?.mainAnalogClockFace.mainHandLayer?.transform = CATransform3DMakeRotation(radian, 0, 0, 1)
        }
    }
    
    func setLapHandAngle(_ radian: CGFloat) {
        CALayer.performWithoutAnimation {
            analogClockView?.mainAnalogClockFace.lapHandLayer?.transform = CATransform3DMakeRotation(radian, 0, 0, 1)
        }
    }
    
    func setSubHandAngle(_ radian: CGFloat) {
        CALayer.performWithoutAnimation {
            analogClockView?.subAnalogClockFace.handLayer?.transform = CATransform3DMakeRotation(radian, 0, 0, 1)
        }
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
    
    func reloadAnalogClockView() {
        pagesStackView?.removeFromSuperview()
        setupPagesStackView(setupDigitalViewPage(), setupAnalogViewPage())
    }
    
    @objc private func pageControlTapped(sender: UIPageControl) {
        UIView.animate(withDuration: 0.33) { [weak self] in
            guard let self = self else { return }
            self.contentOffset.x = CGFloat(sender.currentPage * Int(self.bounds.width))
        }
    }
    
    private func setupScrollViewProperties() {
        translatesAutoresizingMaskIntoConstraints = false
        showsHorizontalScrollIndicator = false
        isPagingEnabled = true
        delegate = self
    }
    
    private func setupPagesStackView(_ digitalView: UIView, _ analogView: UIView) {
        pagesStackView = HorizontalStackView(arrangedSubviews: [digitalView, analogView], distribution: .equalSpacing)
        addSubview(pagesStackView!)
        pagesStackView!.matchParent()
    }
    
    private var digitalStopwatchLabelLeadingConstraintWith4: NSLayoutConstraint?
    private var digitalStopwatchLabelLeadingConstraintWith12: NSLayoutConstraint?
    private var digitalStopwatchLabelTrailingConstraintWith4: NSLayoutConstraint?
    private var digitalStopwatchLabelTrailingConstraintWith12: NSLayoutConstraint?
    
    private func setupDigitalViewPage() -> UIView {
        let digitalView = UIView()
        digitalView.translatesAutoresizingMaskIntoConstraints = false
        digitalView.constraintWidth(equalToConstant: scrollViewSize.width, heightEqualToConstant: scrollViewSize.height)
        
        digitalStopwatchLabel = StopwatchDigitalLabel()
        digitalView.addSubview(digitalStopwatchLabel!)
        digitalStopwatchLabel?.centerYAnchor.constraint(equalTo: digitalView.centerYAnchor).isActive = true
        digitalStopwatchLabelLeadingConstraintWith4 = digitalStopwatchLabel?.leadingAnchor.constraint(equalTo: digitalView.leadingAnchor, constant: 4)
        digitalStopwatchLabelLeadingConstraintWith12 = digitalStopwatchLabel?.leadingAnchor.constraint(equalTo: digitalView.leadingAnchor, constant: 12)
        digitalStopwatchLabelTrailingConstraintWith4 = digitalStopwatchLabel?.trailingAnchor.constraint(equalTo: digitalView.trailingAnchor, constant: -4)
        digitalStopwatchLabelTrailingConstraintWith12 = digitalStopwatchLabel?.trailingAnchor.constraint(equalTo: digitalView.trailingAnchor, constant: -12)
        digitalStopwatchLabelLeadingConstraintWith12?.isActive = true
        digitalStopwatchLabelTrailingConstraintWith12?.isActive = true
        
        return digitalView
    }
    
    private func setupAnalogViewPage() -> UIView {
        let analogView = UIView()
        analogView.translatesAutoresizingMaskIntoConstraints = false
        analogView.constraintWidth(equalToConstant: scrollViewSize.width, heightEqualToConstant: scrollViewSize.height)
        
        let analogClockViewSize = CGSize(width: self.scrollViewSize.height * 0.9, height: self.scrollViewSize.height * 0.9)
        analogClockView = AnalogClockView(size: analogClockViewSize)
        analogView.addSubview(analogClockView!)
        analogClockView?.constraintWidth(equalToConstant: analogClockViewSize.width, heightEqualToConstant: analogClockViewSize.height)
        analogClockView?.centerXYin(analogView)
        
        return analogView
    }
    
    lazy var pageControl = UIPageControl()
    
    private func setupPageControl() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .pageIndicatorColor
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.addTarget(self, action: #selector(pageControlTapped(sender:)), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
