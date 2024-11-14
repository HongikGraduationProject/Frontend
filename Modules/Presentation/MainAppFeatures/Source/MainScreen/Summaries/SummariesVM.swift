//
//  SummariesVM.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/22/24.
//

import UIKit
import Entity
import UseCase
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
        let coordinator: SummariesCO
        let summaryUseCase: SummaryUseCase
        let summaryDetailRepository: SummaryDetailRepository
    }
    
    weak var coordinator: SummariesCO?
    let summaryUseCase: SummaryUseCase
    let summaryDetailRepository: SummaryDetailRepository
    
    // Output
    public var alert: Driver<CapAlertVO>?
    
    // Input
    let requestAllSummaryItems: BehaviorSubject<Void> = .init(value: ())
    
    let disposeBag = DisposeBag()
    
    public init(dependency: Dependency) {
        coordinator = dependency.coordinator
        summaryUseCase = dependency.summaryUseCase
        summaryDetailRepository = dependency.summaryDetailRepository
        
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
    
    public func createAllListVM() -> AllSummaryListVMable {
        AllSummaryListVM(
            coordinator: coordinator,
            summaryUseCase: summaryUseCase,
            summaryDetailRepository: summaryDetailRepository
        )
    }
}
