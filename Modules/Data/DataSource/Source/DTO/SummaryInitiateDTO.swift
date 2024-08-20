//
//  SummaryInitiateDTO.swift
//  DataSource
//
//  Created by choijunios on 8/20/24.
//

import Foundation

public struct SummaryInitiateDTO: Encodable {
    let url: String
    let categoryId: Int?
    let isCategoryIncluded: Bool
    
    public init(url: String, categoryId: Int?) {
        self.url = url
        self.categoryId = categoryId
        self.isCategoryIncluded = categoryId != nil
    }
}
