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
    
    @Injected var authService: AuthService
    
    public func requestSearchedItems(searchWord: String) -> Single<[Int]> {
        .just([])
    }
}
