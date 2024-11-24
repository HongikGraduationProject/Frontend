//
//  SummaryListPageCoordinator.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/18/24.
//

import UIKit

import Entity
import UseCase
import PresentationUtil

import Util

public class SummaryListPageCoordinator: Coordinator {
    
    public var navigationController: UINavigationController
    
    
    public var viewController: UIViewController?
    public var children: [Coordinator] = []
    public var parent: (Coordinator)?
    public var finishDelegate: (CoordinatorFinishDelegate)?
    
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    public func start() {
        
        let viewModel = SummaryListPageViewModel()
        viewModel.showSummaryDetailPage = { [weak self] videoId in
            
            self?.presentDetailPage(videoId: videoId)
        }
        viewModel.presentSearchPage = { [weak self] in
            
            self?.presentSearchPage()
        }
        
        let viewController = SummaryListPageViewController(viewModel: viewModel)
        
        self.viewController = viewController
        
        navigationController.pushViewController(
            viewController,
            animated: false
        )
    }
    
    public func presentDetailPage(videoId: Int) {
        
        // 추후 Coordinator생성
        let vc = SummaryDetailViewController()
        let vm = SummaryDetailViewModel(videoId: videoId)
        
        vc.bind(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
    
    public func presentSearchPage() {
        
        let coordinator = SummarySearchPageCoordinator(
            navigationController: navigationController
        )
        addChild(coordinator)
        coordinator.finishDelegate = self
        coordinator.start()
    }
}

extension SummaryListPageCoordinator: CoordinatorFinishDelegate {
    
    public func coordinatorDidFinish(childCoordinator: any PresentationUtil.Coordinator) {
        
        removeChild(childCoordinator)
    }
}
