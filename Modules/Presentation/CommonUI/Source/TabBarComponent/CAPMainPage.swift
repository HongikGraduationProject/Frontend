//
//  CAPMainPage.swift
//  CommonUI
//
//  Created by choijunios on 8/15/24.
//

import UIKit
import DSKit

public enum CAPMainPage: CaseIterable {
    
    public enum State {
        case idle
        case accent
    }
    
    case home
    case inAppSummary
    case categoryAddition
    case environmentalSetting
    
    public init?(index: Int) {
        switch index {
        case 0: self = .home
        case 1: self = .inAppSummary
        case 2: self = .categoryAddition
        case 3: self = .environmentalSetting
        default: return nil
        }
    }
        
    public func pageOrderNumber() -> Int {
        switch self {
        case .home:
            return 0
        case .inAppSummary:
            return 1
        case .categoryAddition:
            return 2
        case .environmentalSetting:
            return 3
        }
    }
    
    public func tabItemIcon(_ state: State) -> UIImage {
        typealias Images = DSKitAsset.Images
        switch self {
        case .home:
            return (state == .accent ? Images.tabIconHome1 : Images.tabIconHome0).image
        case .inAppSummary:
            return (state == .accent ? Images.tabIconAddsum1 : Images.tabIconAddsum0).image
        case .categoryAddition:
            return (state == .accent ? Images.tabIconAddcat1 : Images.tabIconAddcat0).image
        case .environmentalSetting:
            return (state == .accent ? Images.tabIconSetting1 : Images.tabIconSetting0).image
        }
    }
    
    public func tabItemText() -> String {
        switch self {
        case .home:
            "홈"
        case .inAppSummary:
            "숏폼 추가"
        case .categoryAddition:
            "카테고리 추가"
        case .environmentalSetting:
            "환경설정"
        }
    }
}
