//
//  DefaultSummaryRequestRepository.swift
//  Repository
//
//  Created by choijunios on 8/20/24.
//

import Foundation

import UseCase
import Entity
import DataSource
import Util

import RxSwift

public class DefaultSummaryRequestRepository: SummaryRequestRepository {
    
    // Init
    private let summaryService: SummaryService
    
    public init(summaryService: SummaryService) {
        self.summaryService = summaryService
    }
    
    public func fetchAllSummaryItems() -> RxSwift.Single<[SummaryItem]> {
        summaryService
            .request(api: .listAll, with: .withToken)
            .map(CAPResponse<VideoSummaryList>.self)
            .compactMap { dto in dto.data?.videoSummaryList }
            .map { $0.map { $0.toEntity() } }
            .asObservable()
            .asSingle()
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
            .compactMap { dto in dto.data }
            .map { $0.videoCode }
            .asObservable()
            .asSingle()
    }
}

extension SummaryItemDTO {
    
    func toEntity() -> SummaryItem {
        
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        
        return SummaryItem(
            title: title,
            mainCategory: .init(rawValue: mainCategory)!,
            createdAt: dateFomatter.date(from: createdAt)!,
            videoSummaryId: videoSummaryId
        )
    }
}
