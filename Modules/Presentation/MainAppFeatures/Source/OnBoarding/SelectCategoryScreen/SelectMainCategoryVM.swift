//
//  SelectMainCategoryVM.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/10/24.
//

import UIKit
import BaseFeature
import RxCocoa
import RxSwift
import Entity
import DSKit
import UseCase
import Util

public protocol SelectMainCategoryViewModelable: AnyObject, CategorySelectionCellViewModelable {
    
    // Input
    var nextButtonClicked: PublishRelay<Void> { get }
    
    // Output
    var nextable: Driver<Bool>? { get }
    var selectedCategoryCount: Driver<Int>? { get }
    
    // Config
    var defaultTitleText: String { get }
    var isCategoryCountTitle: Bool { get }
    var coordinator: SelectMainCategoryCO? { get set }
}

public class InitialSelectMainCategoryVM: SelectMainCategoryViewModelable {
    
    // Init
    let userConfigRepository: UserConfigRepository
    public weak var coordinator: SelectMainCategoryCO?
    
    // Config
    public var defaultTitleText: String = "선호하는 카테고리를 선택해 주세요."
    public var isCategoryCountTitle: Bool = true

    // Input
    public var previousSelectedStates: [MainCategory : Driver<Bool>] = [:]
    public var categorySelectionState: PublishRelay<CategoryState> = .init()
    public var nextButtonClicked: PublishRelay<Void> = .init()
    
    // Output
    public var selectedCategoryCount: Driver<Int>?
    public var nextable: Driver<Bool>?
    
    // State
    var editingCategorySelectionState: [MainCategory: Bool] = [:]
    
    let disposeBag: DisposeBag = .init()
    
    public init(userConfigRepository: UserConfigRepository) {
        self.userConfigRepository = userConfigRepository
        
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
        
        nextButtonClicked
            .subscribe { [weak self] _ in
                guard let self else { return }
                
                // 카테고리 저장
                let categories = editingCategorySelectionState
                    .compactMap { (key: MainCategory, value: Bool) in
                        value ? key : nil
                    }
                
                userConfigRepository
                    .savePreferedCategories(categories: categories)
                
                // 카테고리 저장 프로우가 끝났음, 비디오 존재 여부 확인(UseCase)
                printIfDebug("비디오 확인 시작")
            }
            .disposed(by: disposeBag)
        
        // 선택된 카태고리 수를 반환
        selectedCategoryCount = selectionCnt
            .asDriver(onErrorJustReturn: 0)
        
        nextable = selectionCnt
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
    }
}
