//
//  SummaryDetail.swift
//  Entity
//
//  Created by choijunios on 8/18/24.
//

import Foundation

public enum ShortFormPlatform: String, Decodable {
    case youtube="YOUTUBE"
    case instagram="INSTAGRAM"
    case tiktok="TIKTOK"
}
    
public struct SummaryDetail: Decodable {
    
    public let title: String
    public let description: String
    public let keywords: [String]
    public let url: URL
    public let summary: String
    public let address: String
    public let createdAt: Date
    public let platform: ShortFormPlatform
    public let mainCategory: MainCategory
    public let mainCategoryIndex: Int
    public let subCategory: String
    public let subCategoryId: Int
    public let latitude: Double
    public let longitude: Double
    public let videoCode: String
}
