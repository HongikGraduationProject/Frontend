//
//  SummaryDetailRepository.swift
//  UseCase
//
//  Created by choijunios on 8/13/24.
//

import Foundation
import Entity
import RxSwift

public protocol SummaryDetailRepository {
    
    /// 특정비디오의 상세정보를 가져옵니다.
    func fetchSummaryDetail(videoId: Int) -> Single<SummaryDetail>
}
