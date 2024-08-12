//
//  aasd.swift
//  Entity
//
//  Created by choijunios on 8/13/24.
//

import Foundation

public struct VideoSummary: Decodable {
    public let title: String
    public let mainCategory: String
    public let createdAt: String
    public let videoSummaryId: Int
    
    public init(title: String, mainCategory: String, createdAt: String, videoSummaryId: Int) {
        self.title = title
        self.mainCategory = mainCategory
        self.createdAt = createdAt
        self.videoSummaryId = videoSummaryId
    }
}
