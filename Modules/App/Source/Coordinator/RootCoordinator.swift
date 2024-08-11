//
//  RootCoordinator.swift
//  App
//
//  Created by choijunios on 8/11/24.
//

import UIKit
import UseCase
import MainAppFeatures
import BaseFeature

class DefaultRootCoordinator: RootCoordinator {
    
    public struct Dependency {
        let navigationController: UINavigationController
        let injector: Injector
    }
    
    var viewController: UIViewController?
    var navigationController: UINavigationController?
    var finishDelegate: (any BaseFeature.CoordinatorFinishDelegate)?
    
    let injector: Injector
    
    var children: [Coordinator] = []
    var parent: (Coordinator)?
    
    init(dependency: Dependency) {
        self.navigationController = dependency.navigationController
        self.injector = dependency.injector
    }
    
    func start() {
        let vc = RootVC()
        viewController = vc
        
        let vm = RootVM(
            coordinator: self,
            authUseCase: injector.resolve(AuthUseCase.self)
        )
        
        vc.bind(viewModel: vm)
        
        navigationController?.pushViewController(vc, animated: false)
    }
}

extension DefaultRootCoordinator {
    
    func showMainTabBarFlow() {
        
    }
    
    func showCategorySelectionScreen() {
        
    }
    
    func showShortFormHuntingScreen() {
        
    }
}

extension DefaultRootCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        
    }
}