//
//  SearchRequestRepository.swift
//  Shortcap
//
//  Created by choijunios on 11/24/24.
//

import RxSwift

public protocol SearchRequestRepository {
    
    func requestSearchedItems(searchWord: String) -> Single<[Int]>
}
