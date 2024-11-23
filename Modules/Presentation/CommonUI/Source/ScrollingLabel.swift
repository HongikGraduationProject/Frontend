//
//  ScrollingLabel.swift
//  Shortcap
//
//  Created by choijunios on 11/23/24.
//

import UIKit

import DSKit

public class ScrollingLabel: UIScrollView {
    
    private let label: CapLabel
    
    public var text: String {
        get {
            label.text ?? ""
        }
        set {
            label.text = newValue
        }
    }
    
    public init(label: CapLabel) {
        
        self.label = label
        
        super.init(frame: .zero)
        
        setScrollView()
        setLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    private func setScrollView() {
        
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.isScrollEnabled = false
    }
    
    private func setLayout() {
        
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let contentGuide = self.contentLayoutGuide
        let frameGuide = self.frameLayoutGuide
        
        NSLayoutConstraint.activate([
            
            label.topAnchor.constraint(equalTo: frameGuide.topAnchor),
            label.leftAnchor.constraint(equalTo: contentGuide.leftAnchor),
            label.rightAnchor.constraint(equalTo: contentGuide.rightAnchor),
            label.bottomAnchor.constraint(equalTo: frameGuide.bottomAnchor),
        ])
    }
    
    public func stopScrolling() {
        
        self.layer.removeAllAnimations()
        self.contentOffset = .zero
    }
    
    public func startScrolling(speed: CGFloat = 500) {
        
        stopScrolling()
        
        self.layoutIfNeeded()
        
        let originWidth = label.intrinsicContentSize.width
        let currentWidth = self.frame.width
        let distance = originWidth - currentWidth
        
        let duration = distance / speed
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: [
                .repeat,
                .calculationModeLinear,
                .autoreverse
            ],
            animations: {
                
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
                    
                    self.contentOffset = .init(x: distance, y: 0)
                }
            }
        )
    }
}
