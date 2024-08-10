//
//  InitialCoordinator.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/11/24.
//

import UIKit
import UseCase
import BaseFeature

public class InitialCoordinator: Coordinator {
    
    public struct Dependency {
        let authUseCase: AuthUseCase
        weak var finishDelegate: CoordinatorFinishDelegate?
        let navigationController: UINavigationController?
        
        public init(authUseCase: AuthUseCase, finishDelegate: CoordinatorFinishDelegate? = nil, navigationController: UINavigationController?) {
            self.authUseCase = authUseCase
            self.finishDelegate = finishDelegate
            self.navigationController = navigationController
        }
    }
    
    let dependency: Dependency
    
    public var viewController: UIViewController?
    public var navigationController: UINavigationController?
    public weak var finishDelegate: (any BaseFeature.CoordinatorFinishDelegate)?
    
    public var children: [Coordinator] = []
    
    public var parent: (any BaseFeature.Coordinator)?
    
    public init(
        dependency: Dependency
    ) {
        self.dependency = dependency
        self.navigationController = dependency.navigationController
        self.finishDelegate = dependency.finishDelegate
    }
    
    public func start() {
        let vc = InitialVC(coordinator: self)
        viewController = vc
        
        let vm = InitialVM(authUseCase: dependency.authUseCase)
        vc.bind(viewModel: vm)
        
        navigationController?.pushViewController(vc, animated: false)
    }
}
