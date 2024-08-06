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
        let attrText = NSMutableAttributedString()
        
        // 행간높이 설정이 두번째 라인부터 적용되도록 설정하는 코드입니다.
        if let text, !text.isEmpty {
            let splittedText = text.split(separator: "\n")
            
            for (index, line) in splittedText.enumerated() {
                
                if index == 0, attributes[.paragraphStyle] != nil {
                    let attributesForLine1 = currentTypographyStyle.typography.attributes()
                    (attributesForLine1[.paragraphStyle] as! NSMutableParagraphStyle).lineHeightMultiple = 1.0
                    attrText.append(NSAttributedString(string: String(line), attributes: attributesForLine1))
                } else {
                    attrText.append(NSAttributedString(string: String("\n\(line)"), attributes: attributes))
                }
            }
            
            attrText.addAttributes(colorAttribute, range: .init(location: 0, length: attrText.length))
            
            self.attributedText = attrText
        }
    }
}
