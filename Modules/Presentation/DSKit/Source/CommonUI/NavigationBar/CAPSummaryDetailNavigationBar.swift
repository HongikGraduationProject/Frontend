//
//  CAPSummaryDetailNavigationBar.swift
//  DSKit
//
//  Created by choijunios on 8/22/24.
//

import UIKit
import RxSwift


public class CAPSummaryDetailNavigationBar: UIView {
    
    // View
    public let backButton: UIButton = {
        let button = UIButton()
        let image = DSKitAsset.Images.chevronLeft.image
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor = .black
        return button
    }()
    public let titleLabel: CapLabel = {
        let label = CapLabel()
        label.typographyStyle = .largeMedium
        label.attrTextColor = .black
        return label
    }()
    public let optionButton: UIButton = {
        let button = UIButton()
        let image = DSKitAsset.Images.option.image
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor = .black
        return button
    }()
    
    public init(titleText: String) {
        titleLabel.text = titleText
        super.init(frame: .zero)
        setAppearance()
        setLayout()
    }
    public required init?(coder: NSCoder) { return nil }
    
    func setAppearance() {
        self.backgroundColor = DSColors.gray0.color
    }
    
    func setLayout() {
        let viewList = [
            backButton,
            titleLabel,
            optionButton
        ]
        let mainStack = HStack(
            viewList,
            alignment: .center,
            distribution: .equalSpacing
        )
        
        self.layoutMargins = .init(
            top: 6,
            left: 18,
            bottom: 17,
            right: 24
        )
        
        [
            mainStack
        ].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor),
            
            optionButton.widthAnchor.constraint(equalToConstant: 24),
            optionButton.heightAnchor.constraint(equalTo: optionButton.widthAnchor),
            
            mainStack.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            mainStack.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor),
            mainStack.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor),
            mainStack.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
        ])
    }
}

@available(iOS 17.0, *)
#Preview("Preview", traits: .defaultLayout) {
    
    CAPSummaryDetailNavigationBar(titleText: "맛집")
}
