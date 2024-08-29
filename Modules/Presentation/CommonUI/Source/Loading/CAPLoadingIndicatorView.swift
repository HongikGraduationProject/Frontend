//
//  CAPLoadingIndicatorView.swift
//  CommonUI
//
//  Created by choijunios on 8/22/24.
//

import UIKit
import DSKit

public class CAPLoadingIndicatorView: UIView {
    
    let indicator = UIActivityIndicatorView(style: .medium)
    
    public init() {
        super.init(frame: .zero)
        setAppearance()
        setLayout()
    }
    required init?(coder: NSCoder) { return nil }
    
    private func setAppearance() {
        self.backgroundColor = DSColors.gray10.color.withAlphaComponent(0.5)
        self.alpha = 0
    }
    
    private func setLayout() {
        self.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    public func turnOn(withAnimation: Bool = true, duration: CGFloat = 0.2) {
        self.indicator.startAnimating()
        UIView.animate(withDuration: withAnimation ? duration : 0) {
            self.alpha = 1
        }
    }
    
    public func turnOff(withAnimation: Bool = true, duration: CGFloat = 0.2) {
        UIView.animate(withDuration: withAnimation ? duration : 0) {
            self.alpha = 0
        } completion: { _ in
            self.indicator.stopAnimating()
        }
    }
}

@available(iOS 17.0, *)
#Preview("Preview", traits: .defaultLayout) {
    
    let view = CAPLoadingIndicatorView()
    
    DispatchQueue.main.asyncAfter(deadline: .now()+3) {
        view.turnOn()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            view.turnOff()
        }
    }
    
    return view
}
