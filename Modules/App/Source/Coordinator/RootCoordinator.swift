//
//  RootCoordinator.swift
//  App
//
//  Created by choijunios on 8/11/24.
//

import UIKit
import BaseFeature

public protocol RootCoordinator {
    // Flow
    func onBoardingFlow()
    func showMainTabBarFlow()
    
    // Screen
    func showCategorySelectionScreen()
    func showShortFormHuntingScreen()
}

class DefaultRootCoordinator: RootCoordinator {
    
    public struct Dependency {
        let navigationController: UINavigationController
        let injector: Injector
    }
    
    var viewController: UIViewController?
    var navigationController: UINavigationController?
    
    var children: [Coordinator] = []
    var parent: (Coordinator)?
    
    init(dependency: Dependency) {
        self.navigationController = dependency.navigationController
    }
    
    func start() {
        
    }
}

extension DefaultRootCoordinator {
    
    func onBoardingFlow() {
        
    }
    func showMainTabBarFlow() {
        
    }
    
    
    func showCategorySelectionScreen() {
        
    }
    
    
    func showShortFormHuntingScreen() {
        
    }
}
