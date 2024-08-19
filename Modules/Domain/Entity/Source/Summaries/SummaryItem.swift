//
//  SummaryItem.swift
//  Entity
//
//  Created by choijunios on 8/18/24.
//

import Foundation

public struct SummaryItem: Decodable {
    public let title: String
    public let mainCategory: MainCategory
    public let createdAt: String
    public let videoSummaryId: Int
    
    public init(
        title: String,
        mainCategory: MainCategory,
        createdAt: String,
        videoSummaryId: Int
    ) {
        self.title = title
        self.mainCategory = mainCategory
        self.createdAt = createdAt
        self.videoSummaryId = videoSummaryId
    }
}
