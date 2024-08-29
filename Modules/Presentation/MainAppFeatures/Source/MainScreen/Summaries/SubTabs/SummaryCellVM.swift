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
import CommonUI

public class SummaryCellVM: SummaryCellVMable {
    
    public let videoId: Int
    weak var coordinator: SummariesCO?
    
    public var cellClicked: RxRelay.PublishRelay<Void> = .init()
    public var summaryDetail: RxCocoa.Driver<Entity.SummaryDetail>?
    
    let summaryDetailRepository: SummaryDetailRepository
    
    // Observable
    private let summaryDetailRelay: PublishRelay<SummaryDetail> = .init()
    private let disposeBag = DisposeBag()
    
    public init(
        videoId: Int,
        coordinator: SummariesCO?,
        summaryDetailRepository: SummaryDetailRepository
    ) {
        self.videoId = videoId
        self.coordinator = coordinator
        self.summaryDetailRepository = summaryDetailRepository
        
        summaryDetail = summaryDetailRelay
            .asDriver(onErrorDriveWith: .empty())
        
        cellClicked
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.showDetail(videoId: videoId)
            })
            .disposed(by: disposeBag)
    }
    
    public func requestDetail() {
        summaryDetailRepository
            .fetchSummaryDetail(videoId: videoId)
            .asObservable()
            .bind(to: summaryDetailRelay)
            .disposed(by: disposeBag)
    }
}
