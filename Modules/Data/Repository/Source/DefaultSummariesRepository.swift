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

public class DefaultSummariesRepository: SummaryRepository {
    
    let service: SummariesService
    
    public init(service: SummariesService) {
        self.service = service
    }
    
    public func fetchAllSummaryItems() -> RxSwift.Single<[Entity.SummaryItem]> {
        service
            .request(api: .listAll, with: .withToken)
            .map(CAPResponse<VideoSummaryList>.self)
            .map { response in
                response.data!.videoSummaryList
            }
    }
    
    public func checkSummaryState(videoCode: String) -> RxSwift.Single<SummaryStatus> {
        service
            .request(api: .checkSummaryStatus(videoCode: videoCode), with: .withToken)
            .map(CAPResponse<SummaryStatus>.self)
            .map { response in
                response.data!
            }
    }
    
    public func fetchSummaryDetail(videoId: Int) -> RxSwift.Single<Entity.SummaryDetail> {
        service
            .request(api: .fetchSummaryDetail(videoId: videoId), with: .withToken)
            .map(CAPResponse<SummaryDetail>.self)
            .map { response in
                response.data!
            }
    }
}

fileprivate struct VideoSummaryList: Decodable {
    let videoSummaryList: [SummaryItem]
}
