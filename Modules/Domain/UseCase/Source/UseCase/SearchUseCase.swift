//
//  SearchUseCase.swift
//  Shortcap
//
//  Created by choijunios on 11/24/24.
//

import Entity

import RxSwift

public protocol SearchUseCase {
    
    func requestSearchItem(searchWord: String) -> Single<[SummaryItem]>
}

public class DefaultSearchUseCase: SearchUseCase {
    
    
    public func requestSearchItem(searchWord: String) -> Single<[SummaryItem]> {
        .never()
    }
}
