//
//  SummaryCellVM.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/22/24.
//

import Foundation
import Entity
import UseCase
import DSKit
import RxSwift
import RxCocoa

public class SummaryCellVM: SummaryCellVMable {
    
    public let videoId: Int
    
    public var cellClicked: RxRelay.PublishRelay<Void> = .init()
    public var summaryDetail: RxCocoa.Driver<Entity.SummaryDetail>?
    
    let summaryDetailRepository: SummaryDetailRepository
    
    // Observable
    private let summaryDetailRelay: PublishRelay<SummaryDetail> = .init()
    private let disposeBag = DisposeBag()
    
    public init(videoId: Int, summaryDetailRepository: SummaryDetailRepository) {
        self.videoId = videoId
        self.summaryDetailRepository = summaryDetailRepository
        
        summaryDetail = summaryDetailRelay
            .asDriver(onErrorDriveWith: .empty())
    }
    
    public func requestDetail() {
        summaryDetailRepository
            .fetchSummaryDetail(videoId: videoId)
            .asObservable()
            .bind(to: summaryDetailRelay)
            .disposed(by: disposeBag)
    }
}
