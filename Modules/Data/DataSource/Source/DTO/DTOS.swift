//
//  DTOS.swift
//  Shortcap
//
//  Created by choijunios on 11/14/24.
//

import Foundation

public struct VideoCodeDTO: Decodable {
    public let videoCode: String
}

public struct SummaryItemDTO: Decodable {
    
    public let title: String
    public let mainCategory: String
    public let createdAt: String
    public let videoSummaryId: Int
}

public struct VideoSummaryList: Decodable {
    public let videoSummaryList: [SummaryItemDTO]
}

public struct SummaryDetailDTO: Decodable {
    
    public let title: String
    public let description: String
    public let keywords: [String]
    public let url: String
    public let summary: String
    public let address: String
    public let createdAt: String
    public let platform: String
    public let mainCategory: String
    public let mainCategoryIndex: Int
    public let subCategory: String
    public let subCategoryId: Int
    public let latitude: Double?
    public let longitude: Double?
    public let video_code: String
}
