//
//  ClickToStartVM.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/12/24.
//

import UIKit
import PresentationUtil
import RxCocoa
import RxSwift
import Entity
import DSKit
import UseCase
import Util
import AppTrackingTransparency
import AdSupport

public protocol ClickToStartViewModelable {
    
    var nextButtonClicked: PublishRelay<Void> { get }
    var viewWillAppear: PublishRelay<Void> { get }
}

public class ClickToStartViewModel: ClickToStartViewModelable {
    
    // Navigation
    var presentCategorySelectionPage: (() -> ())?
    
    public var nextButtonClicked: PublishRelay<Void> = .init()
    public var viewWillAppear: PublishRelay<Void> = .init()
    
    let disposeBag: DisposeBag = .init()
    
    public init() {
        
        nextButtonClicked
            .subscribe(onNext: { [weak self] _ in
                
                self?.presentCategorySelectionPage?()
            })
            .disposed(by: disposeBag)
    }
}
