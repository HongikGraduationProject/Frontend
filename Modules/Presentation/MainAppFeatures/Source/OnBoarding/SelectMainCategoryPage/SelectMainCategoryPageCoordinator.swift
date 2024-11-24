//
//  SelectMainCategoryCO.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/12/24.
//

import UIKit

import UseCase
import PresentationUtil
import Util

public class SelectMainCategoryPageCoordinator: Coordinator {
    
    public let navigationController: UINavigationController
    
    public var children: [Coordinator] = []
    public weak var parent: (Coordinator)?
    public weak var finishDelegate: (CoordinatorFinishDelegate)?
    
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        
        let viewModel = InitialSelectMainCategoryViewModel()
        viewModel.presentChoosePlatformPage = { [weak self] in
            
            self?.presentChoosePlatformPage()
        }
        viewModel.terminateOnboardingPage = { [weak self] in
            
            self?.terminateOnboardingPage()
        }
        
        let viewController = SelectMainCategoryViewController()
        viewController.bind(viewModel: viewModel)
        
        navigationController.pushViewController(
            viewController,
            animated: true
        )
    }
}

// MARK: InitFlow
extension SelectMainCategoryPageCoordinator {
    
    func terminateOnboardingPage() {
        
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        finish(true)
    }
    
    func presentChoosePlatformPage() {
        
        let coordinator = ChoosePlatformPageCoordinator(
            navigationController: navigationController
        )
        addChild(coordinator)
        coordinator.start()
    }
}
