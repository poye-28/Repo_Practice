//
//  SelectionView.swift
//  Delegate practice
//
//  Created by POYEH on 2020/1/13.
//  Copyright © 2020 POYEH. All rights reserved.
//

import UIKit
import Foundation

protocol SelectionViewDataSource {
    
    func numberOfBtns(_ view: SelectionView) -> Int
    func barItemTitles(_ view: SelectionView, index: Int) -> String
    func IndicatorColor(_ view: SelectionView) -> UIColor
    func tintColor(_ view: SelectionView) -> UIColor
    func fontStyle(_ view: SelectionView) -> UIFont
    func buttonIndex(_ view: SelectionView) -> Int
    
}

extension SelectionViewDataSource {
    
    func numberOfBtns(_ view: SelectionView) -> Int { return 2 }
    func IndicatorColor(_ view: SelectionView) -> UIColor { return UIColor.white }
    func tintColor(_ view: SelectionView) -> UIColor { return UIColor.black }
    func fontStyle(_ view: SelectionView) -> UIFont { return UIFont.systemFont(ofSize: 18) }
    func buttonIndex(_ view: SelectionView) -> Int { return 0 }
    
}

@objc protocol SelectionViewDelegate  {
    
    @objc optional func didSelectItem(_ view: SelectionView, didSelectedItemAt index: Int )
    @objc optional func canSelectItem(_ view: SelectionView, didSelectedItemAt index: Int) -> Bool
    
}

class SelectionView: UIView {
    
    var dataSource: SelectionViewDataSource? {
        didSet {
            setup()
            setupIndicator()
        }
    }
    
    var delegate: SelectionViewDelegate?
    
    var indicatorView = UIView()
    
    var selectedIndex = Int()
    
    var stackView: UIStackView = {
        
        let stack = UIStackView()
        
        stack.axis = NSLayoutConstraint.Axis.horizontal
        
        stack.distribution = UIStackView.Distribution.fillEqually
        
        return stack
        
    }()
    
    var indicatorCenterXConstraint = NSLayoutConstraint()
    
    lazy var indicatorColor = indicatorView.backgroundColor
    
    private func setup() {
        
        guard let dataSource = dataSource else { return }
        
        let factor = dataSource.numberOfBtns(self)
        
        let index = factor - 1
        
        for number in 0...index {
                let button = UIButton()
                button.tag = number
                button.setTitleColor(dataSource.tintColor(self), for: .normal)
                button.setTitle(dataSource.barItemTitles(self, index: number), for: .normal)
                button.addTarget(self, action: #selector(userDidTouchBtn(_:)), for: .touchUpInside)
                stackView.addArrangedSubview(button)
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

    }
    
    private func setupIndicator() {
        guard let dataSource = dataSource else { return }
        
        selectedIndex = dataSource.buttonIndex(self)
        
        let btnReference = stackView.arrangedSubviews[selectedIndex]
        
        indicatorView.backgroundColor = dataSource.IndicatorColor(self)
        
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(indicatorView)
        
        indicatorCenterXConstraint = indicatorView.centerXAnchor.constraint(equalTo: btnReference.centerXAnchor)
        
        NSLayoutConstraint.activate([
            indicatorView.heightAnchor.constraint(equalToConstant: 2),
            indicatorView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / CGFloat(dataSource.numberOfBtns(self))),
            indicatorView.bottomAnchor.constraint(equalTo: btnReference.bottomAnchor),
            indicatorCenterXConstraint
        ])
        
    }
    
    @objc private func userDidTouchBtn(_ sender: UIButton){
        
        guard delegate?.canSelectItem?(self, didSelectedItemAt: sender.tag) == true else { return }
        
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) { [weak self] in
            
            self?.indicatorCenterXConstraint.isActive = false
            
            self?.indicatorCenterXConstraint = (self?.indicatorView.centerXAnchor.constraint(equalTo: sender.centerXAnchor))!
            
            self?.indicatorCenterXConstraint.isActive = true
            
            self?.layoutIfNeeded()
            
        }
        
        animator.startAnimation()
        
        delegate?.didSelectItem?(self, didSelectedItemAt: sender.tag)
        
        selectedIndex = sender.tag
        
    }
    
//    init() {
//        super.init(frame: CGRect())
//        self.setup()
//        self.setupIndicator()
//    }
    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        self.setup()
//        self.setupIndicator()
//    }

    
}
