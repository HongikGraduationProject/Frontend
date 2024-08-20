//
//  SummaryRequestRepository.swift
//  UseCase
//
//  Created by choijunios on 8/20/24.
//

import Foundation
import Entity
import RxSwift

public protocol SummaryRequestRepository {
    
    /// 요약성공한 모든 요약정보를 가져옵니다.
    func fetchAllSummaryItems() -> RxSwift.Single<[Entity.SummaryItem]>
    
    /// 특정 비디오의 요약상태를 확인합니다.
    func checkSummaryState(videoCode: String) -> Single<SummaryStatus>
    
    /// 특정비디오의 요약을 요청합니다.
    func initiateSummary(url: String, category: MainCategory?) -> Single<String>
}
