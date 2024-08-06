//
//  Stack.swift
//  DSKit
//
//  Created by choijunios on 8/6/24.
//

import UIKit

/// 수직으로 아이템을 나열합니다.
open class VStack: UIStackView {
    
    public init(_ elements: [UIView], spacing: CGFloat = 0.0, alignment: UIStackView.Alignment = .center, distribution: UIStackView.Distribution = .fill) {
        
        super.init(frame: .zero)
        
        self.spacing = spacing
        self.axis = .vertical
        self.distribution = distribution
        self.alignment = alignment
        
        elements
            .forEach {
                self.addArrangedSubview($0)
            }
    }
    
    public required init(coder: NSCoder) { fatalError() }
}

/// 수평으로 아이템을 나열합니다.
open class HStack: UIStackView {
    
    public init(_ elements: [UIView], spacing: CGFloat = 0.0, alignment: UIStackView.Alignment = .center, distribution: UIStackView.Distribution = .fill) {
        
        super.init(frame: .zero)
        
        self.spacing = spacing
        self.axis = .horizontal
        self.distribution = distribution
        self.alignment = alignment
        
        elements
            .forEach {
                self.addArrangedSubview($0)
            }
    }
    
    required public init(coder: NSCoder) { fatalError() }
}
