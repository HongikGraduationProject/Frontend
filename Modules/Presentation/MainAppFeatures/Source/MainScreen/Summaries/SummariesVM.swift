//
//  SummariesVM.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/22/24.
//

import UIKit
import Entity
import UseCase
import BaseFeature
import RxCocoa
import RxSwift

public protocol SummariesVMable {
    
    var alert: Driver<CapAlertVO>? { get }
    
    /// 요약학 숏폼 전체조회 화면에 사용되는 VM을 생성합니다.
    func createAllListVM() -> AllSummaryListVMable
}

/// 요약화면 전체를 담당하는 VM입니다.
public class SummariesVM: SummariesVMable {
    
    public struct Dependency {
        let summaryUseCase: SummaryUseCase
        let summaryDetailRepository: SummaryDetailRepository
    }
    
    let summaryUseCase: SummaryUseCase
    let summaryDetailRepository: SummaryDetailRepository
    
    // Output
    public var alert: Driver<CapAlertVO>?
    
    // Observable
    let requestAllSummaryItems: PublishSubject<Void> = .init()
    let disposeBag = DisposeBag()
    
    public init(dependency: Dependency) {
        summaryUseCase = dependency.summaryUseCase
        summaryDetailRepository = dependency.summaryDetailRepository
        
        let requestAllSummaryItemsResult = requestAllSummaryItems
            .flatMap { [summaryUseCase ]_ in
                summaryUseCase
                    .fetchAllSummaryItems()
            }
            .share()
        
        let success = requestAllSummaryItemsResult.compactMap { $0.value }
        let failure = requestAllSummaryItemsResult.compactMap { $0.error }
        
        // MARK: 최초 불러오기에 성공한 경우, 로컬에 저장된 요약목록을 확인합니다.
        success
            .subscribe { [summaryUseCase] _ in
                summaryUseCase.updateSummaryStream()
            }
            .disposed(by: disposeBag)
        
        
        // MARK: 앱이 다시 엑티비 되는 경우, 로컬에 저장된 요약목록을 확인합니다.
        NotificationCenter.default.rx
            .notification(UIApplication.didBecomeActiveNotification)
            .subscribe { [summaryUseCase] _ in
                summaryUseCase.updateSummaryStream()
            }
            .disposed(by: disposeBag)
        
        
        // MARK: Alert, 최초로 리스트를 불러오는 요청이 실패할 경우
        alert = failure
            .map { error in
                CapAlertVO(
                    title: "요약 불러오기 오류",
                    message: error.message,
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
    
    public func createAllListVM() -> AllSummaryListVMable {
        AllSummaryListVM(
            summaryUseCase: summaryUseCase,
            summaryDetailRepository: summaryDetailRepository
        )
    }
}
