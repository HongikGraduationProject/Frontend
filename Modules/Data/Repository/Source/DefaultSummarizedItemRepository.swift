//
//  DefaultSummarizedItemRepository.swift
//  Shortcap
//
//  Created by choijunios on 11/25/24.
//

import Foundation

import RepositoryInterface
import DataSource
import Util
import Entity

import RxSwift

public class DefaultSummarizedItemRepository: SummarizedItemRepository {
    
    // Init
    @Injected private var summaryService: SummaryService
    
    public init() { }
    
    public func requestAllSummaryItems() -> RxSwift.Single<[SummaryItem]> {
        
        summaryService
            .request(api: .listAll, with: .withToken)
            .map(CAPResponse<VideoSummaryList>.self)
            .compactMap { dto in dto.data?.videoSummaryList }
            .map { $0.map { $0.toEntity() } }
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
