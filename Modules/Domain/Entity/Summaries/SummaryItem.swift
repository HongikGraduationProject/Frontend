//
//  SummaryItem.swift
//  Entity
//
//  Created by choijunios on 8/18/24.
//

import Foundation

public struct SummaryItem: Equatable, Hashable {
    public let title: String
    public let mainCategory: MainCategory
    public let createdAt: Date
    public let videoSummaryId: Int
    
    public init(
        title: String,
        mainCategory: MainCategory,
        createdAt: Date,
        videoSummaryId: Int
    ) {
        self.title = title
        self.mainCategory = mainCategory
        self.createdAt = createdAt
        self.videoSummaryId = videoSummaryId
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        
        lhs.videoSummaryId == rhs.videoSummaryId
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(videoSummaryId)
    }
}
