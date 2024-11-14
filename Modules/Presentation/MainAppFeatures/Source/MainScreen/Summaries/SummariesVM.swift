//
//  SummariesVM.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/22/24.
//

import UIKit

import Entity
import UseCase
import CommonUI
import Util


import RxCocoa
import RxSwift

protocol SummariesVMable {
    
    // Output
    var alert: Driver<CapAlertVO> { get }
    var summaryItems: Driver<[SummaryItem]> { get }
    
    func createCellVM(videoId: Int) -> SummaryCellVM
}

/// 요약화면 전체를 담당하는 VM입니다.
class SummariesVM: SummariesVMable {
    
    private weak var coordinator: SummariesCO?
    @Injected private var summaryUseCase: SummaryUseCase
    @Injected private var summaryDetailRepository: SummaryDetailRepository
    
    private let requestAllSummaryItems: BehaviorSubject<Void> = .init(value: ())
    
    // Output
    private(set) var summaryItems: Driver<[SummaryItem]> = .empty()
    var alert: Driver<CapAlertVO> = .empty()
    
    private let disposeBag = DisposeBag()
    
    init(coordinator: SummariesCO) {
        self.coordinator = coordinator
        
        // MARK: 스트림 연결
        summaryItems = summaryUseCase
            .summariesStream
            .observe(on: MainScheduler())
            .asDriver(onErrorJustReturn: [])
        
        
        let requestAllSummaryItemsResult = requestAllSummaryItems
            .withUnretained(self)
            .flatMap { (vm, _) in
                vm.summaryUseCase
                    .requestFetchSummarriedItems()
            }
            .share()
        
        let initialRequestSuccess = requestAllSummaryItemsResult.compactMap { $0.value }
        let initialRequestFailure = requestAllSummaryItemsResult.compactMap { $0.error }
        
        
        // 앱이 다시 엑티비 되는 경우, 로컬에 저장된 요약목록을 확인합니다.
        // 최초 불러오기에 성공한 경우, 로컬에 저장된 요약목록을 확인합니다.
        
        let activeNotification = NotificationCenter.default.rx
            .notification(UIApplication.didBecomeActiveNotification)
            .map({ _ in })
            .asObservable()
        
        Observable
            .merge(initialRequestSuccess, activeNotification)
            .withUnretained(self)
            .subscribe { (vm, _) in
                
                vm.summaryUseCase
                    .requestCheckNewSummary()
            }
            .disposed(by: disposeBag)
        
        
        // MARK: Alert, 최초로 리스트를 불러오는 요청이 실패할 경우
        alert = initialRequestFailure
            .map { error in
                CapAlertVO(title: "요약 불러오기 오류", message: error.message,
                    info: [
                        "닫기": { exit(0) },
                        "재시도하기": { [weak self] in
                            self?.requestAllSummaryItems.onNext(())
                        }
                    ]
                )
            }
            .asDriver(onErrorDriveWith: .never())
    }

    func createCellVM(videoId: Int) -> SummaryCellVM {
        
        let cellVM = SummaryCellVM(videoId: videoId)
        
        cellVM.presentDetailPage = { [weak self] videoId in
            
            self?.coordinator?.showDetail(videoId: videoId)
        }
        
        return cellVM
    }
}
