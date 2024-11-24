//
//  ClickToStartCO.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/12/24.
//

import UIKit

import PresentationUtil
import UseCase
import Util

public class ClickToStartPageCoordinator: Coordinator {
    
    public let navigationController: UINavigationController
    
    
    public var children: [Coordinator] = []
    public weak var parent: (Coordinator)?
    public weak var finishDelegate: (CoordinatorFinishDelegate)?
    
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        
        let viewModel = ClickToStartViewModel()
        viewModel.presentCategorySelectionPage = { [weak self] in
                
            self?.presentCategoryPage()
        }
        
        let viewController = ClickToStartVC()
        viewController.bind(viewModel: viewModel)
        
        navigationController.pushViewController(
            viewController,
            animated: true
        )
    }
}

extension ClickToStartPageCoordinator {
    
    func presentCategoryPage() {
        
        let coordinator = SelectMainCategoryPageCoordinator(
            navigationController: navigationController
        )
        addChild(coordinator)
        coordinator.start()
    }
}
