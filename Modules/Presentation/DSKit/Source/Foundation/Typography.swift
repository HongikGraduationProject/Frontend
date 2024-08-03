//
//  Typography.swift
//  DSKit
//
//  Created by choijunios on 8/4/24.
//

import UIKit

public struct Typography {
    public let font: UIFont
    public let lineHeightMultiple: CGFloat
    public let kerning: CGFloat

    public init(font: UIFont, lineHeightMultiple: CGFloat, kerning: CGFloat) {
        self.font = font
        self.lineHeightMultiple = lineHeightMultiple
        self.kerning = kerning
    }

    public func attributes() -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        return [
            .font: font,
            .kern: kerning,
            .paragraphStyle: paragraphStyle
        ]
    }
}

public enum TypographyStyle {
    case extraLargeRegular
    case extraLargeMedium
    case extraLargeBold
    case largeRegular
    case largeMedium
    case largeBold
    case baseRegular
    case baseMedium
    case baseBold
    case smallRegular
    case smallMedium
    case smallBold
    case tinyRegular
    case tinyMedium
    case tinyBold

    public var typography: Typography {
        switch self {
        case .extraLargeRegular:
            return Typography(font: DSKitFontFamily.Pretendard.regular.font(size: 20), lineHeightMultiple: 1.53, kerning: -0.04)
        case .extraLargeMedium:
            return Typography(font: DSKitFontFamily.Pretendard.medium.font(size: 20), lineHeightMultiple: 1.53, kerning: -0.04)
        case .extraLargeBold:
            return Typography(font: DSKitFontFamily.Pretendard.bold.font(size: 20), lineHeightMultiple: 1.53, kerning: -0.04)
        case .largeRegular:
            return Typography(font: DSKitFontFamily.Pretendard.regular.font(size: 18), lineHeightMultiple: 1.50, kerning: -0.03)
        case .largeMedium:
            return Typography(font: DSKitFontFamily.Pretendard.medium.font(size: 18), lineHeightMultiple: 1.50, kerning: -0.03)
        case .largeBold:
            return Typography(font: DSKitFontFamily.Pretendard.bold.font(size: 18), lineHeightMultiple: 1.50, kerning: -0.03)
        case .baseRegular:
            return Typography(font: DSKitFontFamily.Pretendard.regular.font(size: 16), lineHeightMultiple: 1.45, kerning: -0.02)
        case .baseMedium:
            return Typography(font: DSKitFontFamily.Pretendard.medium.font(size: 16), lineHeightMultiple: 1.45, kerning: -0.02)
        case .baseBold:
            return Typography(font: DSKitFontFamily.Pretendard.bold.font(size: 16), lineHeightMultiple: 1.45, kerning: -0.02)
        case .smallRegular:
            return Typography(font: DSKitFontFamily.Pretendard.regular.font(size: 12), lineHeightMultiple: 1.40, kerning: -0.02)
        case .smallMedium:
            return Typography(font: DSKitFontFamily.Pretendard.medium.font(size: 12), lineHeightMultiple: 1.40, kerning: -0.02)
        case .smallBold:
            return Typography(font: DSKitFontFamily.Pretendard.bold.font(size: 12), lineHeightMultiple: 1.40, kerning: -0.02)
        case .tinyRegular:
            return Typography(font: DSKitFontFamily.Pretendard.regular.font(size: 9), lineHeightMultiple: 1.37, kerning: -0.02)
        case .tinyMedium:
            return Typography(font: DSKitFontFamily.Pretendard.medium.font(size: 9), lineHeightMultiple: 1.37, kerning: -0.02)
        case .tinyBold:
            return Typography(font: DSKitFontFamily.Pretendard.bold.font(size: 9), lineHeightMultiple: 1.37, kerning: -0.02)
        }
    }
}
