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
    public let createdAt: String
    public let platform: ShortFormPlatform
    public let mainCategory: MainCategory
    public let mainCategoryIndex: Int
    public let subCategory: String
    public let subCategoryId: Int
    public let latitude: Double?
    public let longitude: Double?
    public let videoCode: String
    
    public init(
        title: String,
        description: String,
        keywords: [String],
        url: URL,
        summary: String,
        address: String,
        createdAt: String,
        platform: ShortFormPlatform,
        mainCategory: MainCategory,
        mainCategoryIndex: Int,
        subCategory: String,
        subCategoryId: Int,
        latitude: Double?,
        longitude: Double?,
        videoCode: String
    ) {
        self.title = title
        self.description = description
        self.keywords = keywords
        self.url = url
        self.summary = summary
        self.address = address
        self.createdAt = createdAt
        self.platform = platform
        self.mainCategory = mainCategory
        self.mainCategoryIndex = mainCategoryIndex
        self.subCategory = subCategory
        self.subCategoryId = subCategoryId
        self.latitude = latitude
        self.longitude = longitude
        self.videoCode = videoCode
    }
    
    enum CodingKeys: CodingKey {
        case title
        case description
        case keywords
        case url
        case summary
        case address
        case createdAt
        case platform
        case mainCategory
        case mainCategoryIndex
        case subCategory
        case subCategoryId
        case latitude
        case longitude
        case videoCode
    }
}
