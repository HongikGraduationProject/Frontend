//
//  DefaultSummariesRepository.swift
//  Repository
//
//  Created by choijunios on 8/13/24.
//

import Foundation
import UseCase
import Entity
import DataSource
import RxSwift

public class DefaultSummariesRepository: SummariesRepository {

    let service: SummariesService
    
    public init(service: SummariesService) {
        self.service = service
    }
    
    public func getAllVideoList() -> Single<[VideoSummary]> {
        service
            .request(api: .listAll, with: .withToken)
            .map(CAPResponse<VideoSummaryList>.self)
            .map { response in
                response.data?.videoSummaryList ?? []
            }
    }
}

fileprivate struct VideoSummaryList: Decodable {
    let videoSummaryList: [VideoSummary]
}
