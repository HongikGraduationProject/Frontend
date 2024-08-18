//
//  SummaryUseCase.swift
//  UseCase
//
//  Created by choijunios on 8/19/24.
//

import Foundation
import Entity
import RxSwift

public protocol SummaryUseCase {
    
    /// 전체 비디오 상세정보를 제공받을 수 있는 콜드 스트림입니다.
    var summariesStream: BehaviorSubject<[SummaryDetail]> { get }
    
    /// 비디오리스트를 서버로 부터 가져옵니다.
    func fetchAllSummaries() -> Single<Result<Void, SummariesError>>
    
    /// 로컬로부터 비디오 코드를 가져오고 해당 코드로부터 상세정보를 가져옵니다, 가져온 정보는 핫스트림으로 방출됩니다.
    func updateSummaryStream()
}
