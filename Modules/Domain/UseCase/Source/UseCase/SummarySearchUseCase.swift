//
//  SearchUseCase.swift
//  Shortcap
//
//  Created by choijunios on 11/24/24.
//

import Entity
import Util

import RxSwift

public protocol SummarySearchUseCase {
    
    func requestSearchItem(searchWord: String) -> Single<[SummaryDetail]>
}

public class DefaultSummarySearchUseCase: SummarySearchUseCase {
    
    @Injected private var searchRepository: SummarySearchRepository
    @Injected private var detailRepository: SummaryDetailRepository
    
    public init() { }
    
    public func requestSearchItem(searchWord: String) -> Single<[SummaryDetail]> {
        
        searchRepository
            .requestSearchedItems(searchWord: searchWord)
            .flatMap { [detailRepository] items in
                
                let detailObservables = items[0..<10].map { videoId in
                    
                    detailRepository
                        .fetchSummaryDetail(videoId: videoId)
                }
                
                return Single.zip(detailObservables)
            }
    }
}
