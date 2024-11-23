//
//  RootCoordinator.swift
//  App
//
//  Created by choijunios on 8/11/24.
//

import UIKit
import UseCase
import MainAppFeatures
import PresentationUtil

import Util

class DefaultRootCoordinator: RootCoordinator {
    
    var viewController: UIViewController?
    var navigationController: UINavigationController
    var finishDelegate: CoordinatorFinishDelegate?
    
    var children: [Coordinator] = []
    var parent: (Coordinator)?
    
    init(navigationController: UINavigationController) {
        
        self.navigationController = navigationController
    }
    
    func start() {
        
        let viewModel = RootViewModel()
        viewModel.presentMainTabBar = { [weak self] in
            self?.presentMainTabBar()
        }
        viewModel.presentClickToStartPage = { [weak self] in
            self?.presentClickToStartPage()
        }
        viewModel.presentChoosePlatformPage = { [weak self] in
            self?.presentChoosePlatformPage()
        }
        
        
        let viewController = RootViewController()
        viewController.bind(viewModel: viewModel)
        
        
        self.viewController = viewController
        
        
        navigationController.pushViewController(
            viewController,
            animated: false
        )
    }
}

extension DefaultRootCoordinator {
    
    func presentMainTabBar() {
        
        let coordinator = MainScreenCoordinator(
            navigationController: navigationController
        )
        
        addChild(coordinator)
        coordinator.start()
    }
    
    func presentClickToStartPage() {
        
        let coordinator = ClickToStartPageCoordinator(
            navigationController: navigationController
        )
        
        addChild(coordinator)
        coordinator.start()
    }
    
    func presentChoosePlatformPage() {
        
        let coordinator = ChoosePlatformPageCoordinator(
            navigationController: navigationController
        )
        
        addChild(coordinator)
        coordinator.start()
    }
}

extension DefaultRootCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) { }
}
