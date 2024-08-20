//
//  DefaultSummaryRequestRepository.swift
//  Repository
//
//  Created by choijunios on 8/20/24.
//

import UseCase
import Entity
import DataSource
import RxSwift
import Util

public class DefaultSummaryRequestRepository: SummaryRequestRepository {
    
    // Init
    private let summaryService: SummaryService
    
    public init(summaryService: SummaryService) {
        self.summaryService = summaryService
    }
    
    public func fetchAllSummaryItems() -> RxSwift.Single<[Entity.SummaryItem]> {
        summaryService
            .request(api: .listAll, with: .withToken)
            .map(CAPResponse<VideoSummaryList>.self)
            .map { response in
                response.data!.videoSummaryList
            }
    }
    
    public func checkSummaryState(videoCode: String) -> RxSwift.Single<SummaryStatus> {
        summaryService
            .request(api: .checkSummaryStatus(videoCode: videoCode), with: .withToken)
            .map(CAPResponse<SummaryStatus>.self)
            .map { response in
                response.data!
            }
    }
    
    public func initiateSummary(url: String, category: Entity.MainCategory?) -> RxSwift.Single<String> {
        let dto: SummaryInitiateDTO = .init(
            url: url,
            categoryId: category?.index
        )
        return summaryService
            .request(api: .initiateSummary(dto: dto), with: .withToken)
            .map(CAPResponse<VideoCodeDTO>.self)
            .map { dto in
                dto.data!.videoCode
            }
    }
}

fileprivate struct VideoCodeDTO: Decodable {
    let videoCode: String
}

fileprivate struct VideoSummaryList: Decodable {
    let videoSummaryList: [SummaryItem]
}
