//
//  SummarySearchRepository.swift
//  Shortcap
//
//  Created by choijunios on 11/24/24.
//

import RxSwift

public protocol SummarySearchRepository {
    
    func requestSearchedItems(searchWord: String) -> Single<[Int]>
}
