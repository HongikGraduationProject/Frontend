//
//  SummaryLoadingView.swift
//  Shortcap
//
//  Created by choijunios on 11/26/24.
//

import UIKit

import DSKit

class SummaryLoadingView: UIView {
    
    private let loadingIndicator: UIActivityIndicatorView = .init()
    
    private let loadingTextLabel: CapLabel = {
        let label = CapLabel()
        label.typographyStyle = .largeRegular
        label.attrTextColor = DSColors.gray50.color
        label.text = "요약중"
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        setLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    private func setLayout() {
        
        let mainStack = HStack([
            loadingTextLabel,
            loadingIndicator,
        ], spacing: 0, alignment: .center)
        
        self.addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            loadingIndicator.widthAnchor.constraint(equalToConstant: 44),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 44),
            
            mainStack.topAnchor.constraint(equalTo: self.topAnchor),
            mainStack.leftAnchor.constraint(equalTo: self.leftAnchor),
            mainStack.rightAnchor.constraint(equalTo: self.rightAnchor),
            mainStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    func start() {
        self.loadingIndicator.startAnimating()
    }
    func stop() {
        self.loadingIndicator.stopAnimating()
    }
}
