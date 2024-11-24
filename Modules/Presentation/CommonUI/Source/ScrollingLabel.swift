//
//  ScrollingLabel.swift
//  Shortcap
//
//  Created by choijunios on 11/23/24.
//

import UIKit

import DSKit

public class ScrollingLabel: UIScrollView {
    
    // View
    private let label: CapLabel
    
    
    // Animation
    private var animator: UIViewPropertyAnimator?
    
    
    // Util
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
    
    private func startInfiniteScrolling() {
        
        if animator?.state == .active { return }
        
        self.layoutIfNeeded()
        
        let originWidth = label.intrinsicContentSize.width
        let currentWidth = self.frame.width
        let distance = originWidth - currentWidth
        
        if distance <= 0 { return }
        
        let duration = distance / 10
        
        executeAnimation(duration: duration, distance: distance)
    }
    
    private func executeAnimation(duration: TimeInterval, distance: CGFloat) {
        
        let animator = UIViewPropertyAnimator(
            duration: duration,
            curve: .easeInOut
        )
        
        animator.addAnimations { [weak self] in
            
            self?.contentOffset = .init(x: distance, y: 0)
        }
        
        animator.addCompletion { [weak self] _ in
            
            let reversedAnimator = UIViewPropertyAnimator(
                duration: duration,
                curve: .easeInOut
            )
            
            reversedAnimator.addAnimations { [weak self] in
                
                self?.contentOffset = .init(x: 0, y: 0)
            }
            
            reversedAnimator.addCompletion { [weak self] _ in
                
                self?.executeAnimation(duration: duration, distance: distance)
            }
            
            self?.animator = reversedAnimator
            self?.animator?.startAnimation()
        }
        
        self.animator = animator
        self.animator?.startAnimation()
    }
    
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
        
        self.animator?.stopAnimation(true)
        self.animator = nil
        self.contentOffset = .zero
    }
    
    public func startScrolling() {
        
        startInfiniteScrolling()
    }
}
