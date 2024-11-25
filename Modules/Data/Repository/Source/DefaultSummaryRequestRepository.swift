//
//  DefaultSummaryRequestRepository.swift
//  Repository
//
//  Created by choijunios on 8/20/24.
//

import UseCase
import RepositoryInterface
import Entity
import DataSource
import Util

import RxSwift

public class DefaultSummaryRequestRepository: SummaryRequestRepository {
    
    // Init
    @Injected private var summaryService: SummaryService
    
    public init() { }
    
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
            .compactMap { dto in dto.data }
            .map { $0.videoCode }
            .asObservable()
            .asSingle()
    }
}
