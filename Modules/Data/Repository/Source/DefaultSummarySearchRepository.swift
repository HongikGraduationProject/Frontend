//
//  DefaultSummarySearchRepository.swift
//  Shortcap
//
//  Created by choijunios on 11/24/24.
//

import UseCase
import DataSource
import Util

import RxSwift

public class DefualtSummarySearchRepository: SummarySearchRepository {
    
    @Injected var summaryService: SummaryService
    
    public init() { }
    
    public func requestSearchedItems(searchWord: String) -> Single<[Int]> {
        
        summaryService
            .request(api: .search(word: searchWord), with: .withToken)
            .map(CAPResponse<[Int]>.self)
            .map { $0.data ?? [] }
    }
}
