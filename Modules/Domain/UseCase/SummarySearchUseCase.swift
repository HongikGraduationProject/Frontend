//
//  SearchUseCase.swift
//  Shortcap
//
//  Created by choijunios on 11/24/24.
//

import RepositoryInterface
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
                
                // 중복 아이디 제거
                var willRequestItems = Array(Set(items))
                
                if willRequestItems.count > 15 {
                    
                    willRequestItems = Array(willRequestItems[0..<15])
                }
                
                let detailObservables = willRequestItems.map { videoId in
                    
                    detailRepository
                        .fetchSummaryDetail(videoId: videoId)
                        .map { detail in
                            
                            var _detail = detail
                            
                            _detail.videoId = videoId
                            
                            return _detail
                        }
                }
                
                return Single.zip(detailObservables)
            }
    }
}
