//
//  SummaryStatus.swift
//  Entity
//
//  Created by choijunios on 8/19/24.
//

import Foundation

public struct SummaryStatus: Decodable {
    
    public enum Status: String {
        case processing = "PROCESSING"
        case complete = "COMPLETE"
    }
    
    public let status: Status
    public let videoSummaryId: Int
    
    enum CodingKeys: CodingKey {
        case status
        case videoSummaryId
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = Status(rawValue: try container.decode(String.self, forKey: .status))!
        self.videoSummaryId = try container.decode(Int.self, forKey: .videoSummaryId)
    }
}
