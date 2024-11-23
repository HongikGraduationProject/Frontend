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
    
    
    public var viewController: UIViewController?
    public var children: [Coordinator] = []
    public var parent: (Coordinator)?
    public var finishDelegate: (CoordinatorFinishDelegate)?
    
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    public func start() {
        
        let viewModel = SummarySearchPageViewModel()
        
        let viewController = SummarySearchPageViewController()
        viewController.bind(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
