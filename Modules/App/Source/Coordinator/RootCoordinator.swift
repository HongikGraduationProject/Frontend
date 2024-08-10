//
//  RootCoordinator.swift
//  App
//
//  Created by choijunios on 8/11/24.
//

import UIKit
import UseCase
import MainAppFeatures
import BaseFeature

public protocol RootCoordinator: Coordinator {
    // Flow
    func tokenFlow()
    func categorySelectionFlow()
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
    var finishDelegate: (any BaseFeature.CoordinatorFinishDelegate)?
    
    let injector: Injector
    
    var children: [Coordinator] = []
    var parent: (Coordinator)?
    
    init(dependency: Dependency) {
        self.navigationController = dependency.navigationController
        self.injector = dependency.injector
    }
    
    func start() {
        tokenFlow()
    }
}

extension DefaultRootCoordinator {
    
    func tokenFlow() { 
        let initialCoordinator: InitialCoordinator = .init(
            dependency: .init(
                authUseCase: injector.resolve(AuthUseCase.self),
                navigationController: navigationController
            )
        )
        addChild(initialCoordinator)
        
        initialCoordinator.start()
    }
    
    func categorySelectionFlow() { 
        
    }
    
    func showMainTabBarFlow() {
        
    }
    
    func showCategorySelectionScreen() {
        
    }
    
    func showShortFormHuntingScreen() {
        
    }
}
