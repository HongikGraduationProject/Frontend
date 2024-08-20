//
//  MainCategory.swift
//  Entity
//
//  Created by choijunios on 8/6/24.
//

import Foundation

public enum MainCategory: String, CaseIterable, Decodable {
    case all = "ALL"
    case technology = "TECHNOLOGY"
    case beauty = "BEAUTY"
    case cook = "COOK"
    case living = "LIVING"
    case health = "HEALTH"
    case travel = "TRAVEL"
    case art = "ART"
    case news = "NEWS"
    case entertainment = "ENTERTAINMENT"
    case other = "OTHER"
    
    public static var allCasesExceptAll: [MainCategory] {
        self.allCases.filter { $0 != .all }
    }
    
    public var pageOrderNumber: Int {
        switch self {
        case .all:
            0
        case .technology:
            1
        case .beauty:
            2
        case .cook:
            3
        case .living:
            4
        case .health:
            5
        case .travel:
            6
        case .art:
            7
        case .news:
            8
        case .entertainment:
            9
        case .other:
            10
        }
    }
    
    public var index: Int {
        switch self {
        case .all:
            10
        case .technology:
            0
        case .beauty:
            1
        case .cook:
            2
        case .living:
            3
        case .health:
            4
        case .travel:
            5
        case .art:
            6
        case .news:
            7
        case .entertainment:
            8
        case .other:
            9
        }
    }

    public var korWordText: String {
        switch self {
        case .technology:
            return "기술"
        case .beauty:
            return "뷰티"
        case .cook:
            return "요리"
        case .living:
            return "리빙"
        case .health:
            return "건강"
        case .travel:
            return "여행"
        case .art:
            return "예술"
        case .news:
            return "뉴스"
        case .entertainment:
            return "엔터테인먼트"
        case .other:
            return "기타"
        case .all:
            return "전체"
        }
    }
}
