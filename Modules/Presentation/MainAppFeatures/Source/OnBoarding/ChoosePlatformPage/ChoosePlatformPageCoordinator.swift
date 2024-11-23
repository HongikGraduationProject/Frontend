//
//  ChoosePlatformPageCoordinator.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/13/24.
//

import UIKit

import PresentationUtil
import UseCase
import Util

public class ChoosePlatformPageCoordinator: Coordinator {
    
    @Injected var videoCodeRepository: VideoCodeRepository
    
    
    public let navigationController: UINavigationController
    
    
    public var viewController: UIViewController?
    public var children: [Coordinator] = []
    public var parent: (Coordinator)?
    public var finishDelegate: (CoordinatorFinishDelegate)?
    
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    public func start() {
        
        let viewModel = ChoosePlatformPageViewModel()
        viewModel.presentMainTabBar = { [weak self] in
            
            self?.presentMainTapBar()
        }
        
        let viewController = ChoosePlatformPageViewController()
        viewController.bind(viewModel: viewModel)
        
        navigationController.pushViewController(
            viewController,
            animated: true
        )
    }
    
    public func presentMainTapBar() {
        
        let coordinator = MainScreenCoordinator(
            navigationController: navigationController
        )
        
        addChild(coordinator)
        coordinator.start()
    }
}
