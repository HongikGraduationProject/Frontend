//
//  SummaryItem.swift
//  Entity
//
//  Created by choijunios on 8/18/24.
//

import Foundation

public struct SummaryItem {
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
}
