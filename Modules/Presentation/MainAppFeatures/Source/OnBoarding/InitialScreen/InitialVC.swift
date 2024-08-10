//
//  InitialVC.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/11/24.
//

import UIKit
import BaseFeature
import RxCocoa
import RxSwift
import Entity
import DSKit

public protocol InitialViewModelable: BaseVMable {
    // Input
    var viewDidLoad: PublishRelay<Void> { get }
    
    // Output
    var tokenFlowNextable: Driver<Void> { get }
}

public class InitialVC: BaseVC {
    
    weak var coordinator: Coordinator?
    
    var viewModel: InitialViewModelable?
    
    // Init
    
    // View
    
    // Observable
    private let disposeBag = DisposeBag()
    
    public init(coordinator: Coordinator) {
        self.coordinator = coordinator
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
    
    public func bind(viewModel: InitialViewModelable) {
        
        self.viewModel = viewModel
        
        // Output
        viewModel
            .tokenFlowNextable
            .drive(onNext: { [weak coordinator] _ in
                coordinator?.finish(false)
            })
            .disposed(by: disposeBag)
        
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

