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
}
