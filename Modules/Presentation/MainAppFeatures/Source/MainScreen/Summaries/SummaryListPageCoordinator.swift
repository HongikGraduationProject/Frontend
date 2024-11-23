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
    
    @Injected var summaryUseCase: SummaryUseCase
    @Injected var summaryDetailRepository: SummaryDetailRepository
    
    
    public var navigationController: UINavigationController
    
    
    public var viewController: UIViewController?
    public var children: [Coordinator] = []
    public var parent: (Coordinator)?
    public var finishDelegate: (CoordinatorFinishDelegate)?
    
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    public func start() {
        
        let viewModel = SummaryDetailPageViewModel()
        
        viewModel.showSummaryDetailPage = { [weak self] videoId in
            
            self?.presentDetailPage(videoId: videoId)
        }
        
        let viewController = SummaryDetailPageViewController(viewModel: viewModel)
        
        self.viewController = viewController
        
        navigationController.pushViewController(
            viewController,
            animated: false
        )
    }
    
    public func presentDetailPage(videoId: Int) {
        
        // 추후 Coordinator생성
        let vc = SummaryDetailViewController()
        let vm = SummaryDetailViewModel(videoId: videoId, repo: summaryDetailRepository)
        
        vc.bind(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
}
