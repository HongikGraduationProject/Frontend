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

public protocol SelectMainCategoryViewModelable: CategorySelectionCellViewModelable {
    var nextable: Driver<Bool>? { get }
}

public class SelectMainCategoryVM: SelectMainCategoryViewModelable {

    // Input
    public var previousSelectedStates: [MainCategory : Driver<Bool>] = [:]
    public var categorySelectionState: PublishRelay<CategoryState> = .init()
    
    // Output
    public var selectedCategoriesCount: Driver<Int>?
    public var nextable: Driver<Bool>?
    
    var editingState: [MainCategory: Bool] = [:]
    
    init() {
        
        // Input
        let selectionCnt = categorySelectionState
            .compactMap { [weak self] result in
                
                print("\(result.category.korWordText) : \(result.isActive ? "활성화" : "비활성화")")
                self?.editingState[result.category] = result.isActive
                
                let activeCategoryCnt = self?.editingState.reduce(0) { (partialResult, arg1) in
                    let (category, isActive) = arg1
                    // 활성화 상태인 카테고리수만 1을 더한다.
                    return partialResult + (isActive ? 1 : 0)
                }
                
                return activeCategoryCnt
            }
            .share()
        
        // 선택된 카태고리 수를 반환
        selectedCategoriesCount = selectionCnt
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
