//
//  SummaryRepository.swift
//  UseCase
//
//  Created by choijunios on 8/13/24.
//

import Foundation
import Entity
import RxSwift

public protocol SummaryRepository {
    
    /// 요약성공한 모든 요약정보를 가져옵니다.
    func fetchAllSummaryItems() -> Single<[SummaryItem]>
    
    /// 특정 비디오의 요약상태를 확인합니다.
    func checkSummaryState(videoCode: String) -> Single<SummaryStatus>
    
    /// 특정비디오의 상세정보를 가져옵니다.
    func fetchSummaryDetail(videoId: Int) -> Single<SummaryDetail>
}
