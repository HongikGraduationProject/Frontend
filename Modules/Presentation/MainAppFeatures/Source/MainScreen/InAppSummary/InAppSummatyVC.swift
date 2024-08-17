//
//  InAppSummatyVC.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/18/24.
//

import UIKit
import BaseFeature
import RxCocoa
import RxSwift
import Entity
import DSKit

public class InAppSummatyVC: BaseVC {
    
    // Init
    
    // View
    
    // Observable
    private let disposeBag = DisposeBag()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) { fatalError() }
    
    private func setAppearance() {
        view.backgroundColor = .yellow
    }
    
    private func setLayout() {
        
    }
    
    private func setObservable() {
        
    }
}

