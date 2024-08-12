//
//  ClickToStartVM.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/12/24.
//

import UIKit
import BaseFeature
import RxCocoa
import RxSwift
import Entity
import DSKit
import UseCase
import Util

public protocol ClickToStartViewModelable {
    
    var nextButtonClicked: PublishRelay<Void> { get }
}

public class ClickToStartVM: ClickToStartViewModelable {
    
    public weak var coordinator: ClickToStartCO?
    
    public var nextButtonClicked: PublishRelay<Void> = .init()
    
    let disposeBag: DisposeBag = .init()
    
    public init() {
        
        nextButtonClicked
            .subscribe(onNext: { [weak self] _ in
                
                self?.coordinator?.showCategoryScreen()
            })
            .disposed(by: disposeBag)
    }
}


