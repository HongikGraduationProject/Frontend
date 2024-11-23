//
//  SearchUseCase.swift
//  Shortcap
//
//  Created by choijunios on 11/24/24.
//

import Entity

import RxSwift

public protocol SummarySearchUseCase {
    
    func requestSearchItem(searchWord: String) -> Single<[SummaryItem]>
}

public class DefaultSummarySearchUseCase: SummarySearchUseCase {
    
    
    public func requestSearchItem(searchWord: String) -> Single<[SummaryItem]> {
        .never()
    }
}
