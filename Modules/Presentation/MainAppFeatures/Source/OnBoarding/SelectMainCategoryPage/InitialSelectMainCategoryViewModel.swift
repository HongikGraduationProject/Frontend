//
//  SelectMainCategoryVM.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/10/24.
//

import UIKit
import RxCocoa
import RxSwift
import Entity
import DSKit
import UseCase
import Util
import CommonUI
import PresentationUtil

public protocol SelectMainCategoryViewModelable: AnyObject, BaseVMable, CategorySelectionCellViewModelable {
    
    // Input
    var nextButtonClicked: PublishRelay<Void> { get }
    
    // Output
    var nextButtonIsActive: Driver<Bool>? { get }
    var selectedCategoryCount: Driver<Int>? { get }
}

public class InitialSelectMainCategoryViewModel: SelectMainCategoryViewModelable {
    
    @Injected var onBoardingUseCase: OnBoardingCheckUseCase
    @Injected var userConfigRepository: UserConfigRepository
    
    
    // Navigation
    var terminateOnboardingPage: (() -> ())?
    var presentChoosePlatformPage: (() -> ())?
    
    
    // Input
    public var previousSelectedStates: [MainCategory : Driver<Bool>] = [:]
    public var categorySelectionState: PublishRelay<CategoryState> = .init()
    public var nextButtonClicked: PublishRelay<Void> = .init()
    
    // Output
    public var selectedCategoryCount: Driver<Int>?
    public var nextButtonIsActive: Driver<Bool>?
    public var alert: Driver<CapAlertVO>?
    
    // State
    var editingCategorySelectionState: [MainCategory: Bool] = [:]
    
    let disposeBag: DisposeBag = .init()
    
    public init() {
        
        // Input
        let selectionCnt = categorySelectionState
            .compactMap { [weak self] result in
                
                print("\(result.category.korWordText) : \(result.isActive ? "활성화" : "비활성화")")
                
                // 수정상태를 기록
                self?.editingCategorySelectionState[result.category] = result.isActive
                
                let activeCategoryCnt = self?.editingCategorySelectionState.reduce(0) { (partialResult, arg1) in
                    let (_, isActive) = arg1
                    // 활성화 상태인 카테고리수만 1을 더한다.
                    return partialResult + (isActive ? 1 : 0)
                }
                
                return activeCategoryCnt
            }
            .share()
        
        let categorySaveFinished = nextButtonClicked
            .compactMap { [weak self] _ -> Void? in
                guard let self else { return nil }
                
                // 카테고리 저장
                let categories = editingCategorySelectionState
                    .compactMap { (key: MainCategory, value: Bool) in
                        value ? key : nil
                    }
                
                userConfigRepository
                    .savePreferedCategories(categories: categories)
                
                return ()
            }
        
        // MARK: 저장된 숏폼이 있는지 확인
        let checkingSummariesResult = categorySaveFinished
            .flatMap { [onBoardingUseCase] _ in
                onBoardingUseCase.checkingSummariesExists()
            }
            .share()
        
        let checkingSummariesSuccess = checkingSummariesResult.compactMap { $0.value }
        let checkingSummariesFailure = checkingSummariesResult.compactMap { $0.error }
        
        checkingSummariesSuccess
            .withUnretained(self)
            .subscribe(onNext: { (viewModel, isExists) in
                if isExists {
                    
                    viewModel.terminateOnboardingPage?()
                    
                } else {
                    
                    viewModel.presentChoosePlatformPage?()
                    
                }
            })
            .disposed(by: disposeBag)
        
        // 선택된 카태고리 수를 반환
        selectedCategoryCount = selectionCnt
            .asDriver(onErrorJustReturn: 0)
        
        nextButtonIsActive = selectionCnt
            .map { cnt in
                // 선택된 카테고리 수가 최소 1개이상이야 화면을 넘어갈 수 있음
                cnt > 0
            }
            .asDriver(onErrorJustReturn: false)
        
        // Output
        MainCategory.allCasesExceptAll
            .forEach { category in
                let relay = BehaviorRelay<Bool>(value: false)
                previousSelectedStates[category] = relay.asDriver()
            }
        
        // 토큰 생성 실패
        alert = checkingSummariesFailure.map { $0.message }
            .map { message in
                return CapAlertVO(
                    title: "시스템 오류",
                    message: message,
                    info: [
                        "닫기": {
                            // 어플리케이션을 강제 종료합니다.
                            exit(0)
                        }
                    ]
                )
            }
            .asDriver(onErrorJustReturn: .default)
    }
}
