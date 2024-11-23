//
//  SummaryCellContentView.swift
//  Shortcap
//
//  Created by choijunios on 11/24/24.
//

import UIKit

import Entity
import DSKit
import CommonUI

class SummaryCellContentView: TappableUIView {
    // View
    let videoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.backgroundColor = DSColors.gray30.color
        return view
    }()
    
    let titleLabel: ScrollingLabel = {
        let label = CapLabel()
        label.typographyStyle = .extraLargeBold
        label.attrTextColor = DSColors.primary80.color
        label.textAlignment = .left
        
        let scrollingLabel: ScrollingLabel = .init(label: label)
        
        return scrollingLabel
    }()
    
    let categoryLabel: CapLabel = {
        let label = CapLabel()
        label.typographyStyle = .smallRegular
        label.attrTextColor = DSColors.gray50.color
        label.textAlignment = .left
        return label
    }()
    
    override init() {
        super.init()
        
        setAppearance()
        setLayout()
    }
    required init?(coder: NSCoder) { return nil }
    
    private func setAppearance() {
        self.backgroundColor = DSColors.gray0.color
    }
    
    private func setLayout() {
        let labelStack = VStack(
            [
                titleLabel,
                categoryLabel
            ],
            alignment: .fill
        )
        
        let summaryCaptionStack = VStack(
            [
                labelStack,
                Spacer()
            ],
            alignment: .fill
        )
        
        let mainStack = HStack(
            [
                videoImageView,
                summaryCaptionStack,
            ],
            spacing: 15,
            alignment: .fill
        )
        mainStack.isUserInteractionEnabled = false
        
        self.addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        videoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            videoImageView.widthAnchor.constraint(equalToConstant: 120),
            
            mainStack.topAnchor.constraint(equalTo: self.topAnchor),
            mainStack.leftAnchor.constraint(equalTo: self.leftAnchor),
            mainStack.rightAnchor.constraint(equalTo: self.rightAnchor),
            mainStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    func prepareForeReuse() {
        videoImageView.image = nil
        titleLabel.text = ""
        categoryLabel.text = ""
        
        titleLabel.stopScrolling()
    }
}
