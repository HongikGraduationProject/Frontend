//
//  SummaryCellVM.swift
//  Shortcap
//
//  Created by choijunios on 11/14/24.
//

import Foundation

import Entity
import UseCase
import DSKit
import Util


import RxSwift
import RxCocoa

protocol SummaryCellVMable {
    
    /// 비디오 아이디
    var videoId: Int { get }
    
    /// 상세정보를 요청합니다.
    func requestDetail()
    
    /// Input: 셀이 클릭됨
    var cellClicked: PublishRelay<Void> { get }
    
    /// Ouptut: 요약 상세정보를 가져옵니다.
    var summaryDetail: Driver<SummaryDetail>? { get }
}

class SummaryCellVM: SummaryCellVMable {
    
    @Injected var summaryDetailRepository: SummaryDetailRepository
    
    let videoId: Int
    
    // Navigation
    var presentDetailPage: ((Int) -> ())?
    
    
    var cellClicked: RxRelay.PublishRelay<Void> = .init()
    var summaryDetail: RxCocoa.Driver<Entity.SummaryDetail>?
    
    
    
    // Observable
    private let summaryDetailRelay: PublishRelay<SummaryDetail> = .init()
    private let disposeBag = DisposeBag()
    
    init(videoId: Int) {
        self.videoId = videoId
        
        summaryDetail = summaryDetailRelay
            .asDriver(onErrorDriveWith: .empty())
        
        cellClicked
            .subscribe(onNext: { [weak self] in
                
                self?.presentDetailPage?(videoId)
            })
            .disposed(by: disposeBag)
    }
    
    func requestDetail() {
        summaryDetailRepository
            .fetchSummaryDetail(videoId: videoId)
            .asObservable()
            .bind(to: summaryDetailRelay)
            .disposed(by: disposeBag)
    }
}
