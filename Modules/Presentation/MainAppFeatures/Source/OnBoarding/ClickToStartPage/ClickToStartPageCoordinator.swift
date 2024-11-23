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
    
    public var viewController: UIViewController?
    public let navigationController: UINavigationController
    
    public var children: [Coordinator] = []
    public var parent: (Coordinator)?
    public var finishDelegate: (CoordinatorFinishDelegate)?
    
    @Injected var userConfigRepository: UserConfigRepository
    @Injected var videoCodeRepository: VideoCodeRepository
    @Injected var onBoardingCheckUseCase: OnBoardingCheckUseCase
    
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
