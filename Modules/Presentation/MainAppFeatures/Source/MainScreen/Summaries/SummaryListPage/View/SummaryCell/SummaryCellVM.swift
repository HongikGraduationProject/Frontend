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
    var cellClicked: PublishSubject<Void> { get }
    
    /// Ouptut: 요약 상세정보를 가져옵니다.
    var summaryDetail: Driver<SummaryDetail> { get }
    
    func requestDateDiffText(date: Date) -> String
}

class SummaryCellVM: SummaryCellVMable {
    
    @Injected var summaryDetailRepository: SummaryDetailRepository
    
    let videoId: Int
    
    // Navigation
    var presentDetailPage: ((Int) -> ())?
    
    
    // Input
    let cellClicked: PublishSubject<Void> = .init()
    
    
    // Output
    var summaryDetail: Driver<Entity.SummaryDetail> = .empty()
    var startScrollingTitleLabel: Driver<Void> = .empty()
    
    
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
    
    func requestDateDiffText(date: Date) -> String {
        
        let dateDiff = Calendar.current
            .dateComponents([.day, .hour, .minute], from: date, to: .now)
        
        guard let day = dateDiff.day, let hour = dateDiff.hour, let minute = dateDiff.minute else { return "이전 업데이트" }
        
        if day > 0 {
            return "\(day)일 전 업데이트"
        } else if hour > 0 {
            return "\(hour)시간 전 업데이트"
        } else if minute > 0 {
            return "\(minute)분 전 업데이트"
        } else {
            return "방금전 업데이트"
        }
    }
}
