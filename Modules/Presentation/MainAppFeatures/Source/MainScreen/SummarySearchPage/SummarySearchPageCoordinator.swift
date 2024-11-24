//
//  SummarySearchPageCoordinator.swift
//  Shortcap
//
//  Created by choijunios on 11/24/24.
//

import UIKit

import UseCase
import PresentationUtil
import Util

public class SummarySearchPageCoordinator: Coordinator {
    
    public var navigationController: UINavigationController
    
    
    public var children: [Coordinator] = []
    public weak var parent: (Coordinator)?
    public weak var finishDelegate: (CoordinatorFinishDelegate)?
    
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    public func start() {
        
        let viewModel = SummarySearchPageViewModel()
        viewModel.exitPage = { [weak self] in
            guard let self else { return }
            
            finish(true)
        }
        viewModel.presentDetailPage = { [weak self] id in
            self?.presentDetailPage(videoId: id)
        }
        
        let viewController = SummarySearchPageViewController()
        viewController.bind(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    public func presentDetailPage(videoId: Int) {
        
        // 추후 Coordinator생성
        let vc = SummaryDetailViewController()
        let vm = SummaryDetailViewModel(videoId: videoId)
        
        vc.bind(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
}
