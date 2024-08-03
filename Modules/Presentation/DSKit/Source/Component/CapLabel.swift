//
//  CapLabel.swift
//  DSKit
//
//  Created by choijunios on 8/4/24.
//

import UIKit

public class CapLabel: UILabel {
    
    private var currentTypographyStyle: TypographyStyle = .baseMedium
    private var currentAttrTextColor: UIColor = .black
    
    /// [즉시 반영] CapLabel이 표시할 문자열을 지정합니다.
    public override var text: String? {
        get {
            super.text
        }
        set {
            super.text = newValue
            updateText()
        }
    }
    
    /// [즉시 반영] CapLabel이 표시할 문자열을 색상을 표시합니다.
    public var attrTextColor: UIColor {
        get {
            currentAttrTextColor
        }
        set {
            currentAttrTextColor = newValue
            updateText()
        }
    }
    
    /// [즉시 반영] CapLabel이 표시할 문자열의 typographyStyle를 지정합니다.
    public var typographyStyle: TypographyStyle {
        get {
            currentTypographyStyle
        }
        set {
            currentTypographyStyle = newValue
            updateText()
        }
        
    }
    
    public init() {
        
        super.init(frame: .zero)
    }
    public required init?(coder: NSCoder) { fatalError() }
    
    
    private func updateText() {
        
        let attributes = currentTypographyStyle.typography.attributes()
        let colorAttribute: [NSAttributedString.Key: Any] = [.foregroundColor: currentAttrTextColor]
        let finalAttributes = colorAttribute.merging(attributes) { first, _ in first }
        
        if let text = self.text {
            self.attributedText = NSAttributedString(string: text, attributes: finalAttributes)
        }
    }
}
