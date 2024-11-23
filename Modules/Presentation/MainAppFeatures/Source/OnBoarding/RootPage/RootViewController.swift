//
//  InitialVC.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/11/24.
//

import UIKit
import RxCocoa
import RxSwift
import Entity
import DSKit
import PresentationUtil

public class RootViewController: BaseVC {
    
    private var viewModel: RootViewModelable?
    
    // Init
    
    // View
    
    // Observable
    private let disposeBag = DisposeBag()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    public required init?(coder: NSCoder) { fatalError() }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setAppearance()
        setLayout()
        setObservable()
    }
    
    private func setAppearance() {
        view.backgroundColor = DSKitAsset.Colors.gray0.color
    }
    
    private func setLayout() {
        
    }
    
    private func setObservable() {
        
    }
    
    public func bind(viewModel: RootViewModelable) {
        
        self.viewModel = viewModel
        
        // Output
        viewModel
            .alert?
            .drive(onNext: { [weak self] alertVO in
                self?.showAlert(alertVO: alertVO)
            })
            .disposed(by: disposeBag)
        
        // Input
        rx.viewDidLoad
            .bind(to: viewModel.viewDidLoad)
            .disposed(by: disposeBag)
    }
}

