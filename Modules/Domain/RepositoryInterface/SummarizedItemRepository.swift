//
//  SummarizedItemRepository.swift
//  Shortcap
//
//  Created by choijunios on 11/25/24.
//

import Entity

import RxSwift

public protocol SummarizedItemRepository {
    
    /// 요약성공한 모든 요약정보를 가져옵니다.
    func requestAllSummaryItems() -> Single<[SummaryItem]>
}
