//
//  MainCategory.swift
//  Entity
//
//  Created by choijunios on 8/6/24.
//

import Foundation

public enum MainCategory: Int, CaseIterable {
    case technology = 0
    case beauty = 1
    case cook = 2
    case living = 3
    case health = 4
    case travel = 5
    case art = 6
    case news = 7
    case entertainment = 8
    case other = 9
    case all = 10
    
    public static var allCasesExceptAll: [MainCategory] {
        self.allCases.filter { $0 != .all }
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
