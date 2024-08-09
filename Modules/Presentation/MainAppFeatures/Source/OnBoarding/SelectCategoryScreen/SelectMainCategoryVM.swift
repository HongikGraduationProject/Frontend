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

public class SelectMainCategoryVM: CategorySelectionCellViewModelable {
    
    public var previousSelectedStates: [Entity.MainCategory : RxCocoa.Driver<Bool>] = [:]
    public var categorySelectionState: RxRelay.PublishRelay<DSKit.CategoryState> = .init()
    
    let disposeBag: DisposeBag = .init()
    
    init() {
        
        // Input
        categorySelectionState
            .subscribe(onNext: { result in
                
                print("\(result.category.korWordText) : \(result.isActive ? "활성화" : "비활성화")")
            })
            .disposed(by: disposeBag)
        
        // Output
        MainCategory.allCasesExceptAll
            .forEach { category in
                let relay = BehaviorRelay<Bool>(value: false)
                previousSelectedStates[category] = relay.asDriver()
            }
    }
}
