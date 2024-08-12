//
//  SummariesRepository.swift
//  UseCase
//
//  Created by choijunios on 8/13/24.
//

import Foundation
import Entity
import RxSwift

public protocol SummariesRepository {
    
    /// 요약이 완료된 전체 비디오 리스트 정보를 가져옵니다.
    func getAllVideoList() -> Single<Result<[VideoSummary], SummariesError>>
}
