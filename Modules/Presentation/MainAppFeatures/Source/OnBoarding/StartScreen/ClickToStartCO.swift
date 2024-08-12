//
//  ClickToStartCO.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/12/24.
//

import UIKit
import BaseFeature
import UseCase

public class ClickToStartCO: Coordinator {
    
    public struct Dependency {
        let userConfigRepository: UserConfigRepository
        let navigationController: UINavigationController?
        
        public init(userConfigRepository: UserConfigRepository, navigationController: UINavigationController?) {
            self.userConfigRepository = userConfigRepository
            self.navigationController = navigationController
        }
    }
    
    public var viewController: UIViewController?
    public var navigationController: UINavigationController?
    
    public var children: [any BaseFeature.Coordinator] = []
    public var parent: (any BaseFeature.Coordinator)?
    public var finishDelegate: (any BaseFeature.CoordinatorFinishDelegate)?
    
    let userConfigRepository: UserConfigRepository
    
    public init(dependency: Dependency) {
        self.navigationController = dependency.navigationController
        self.userConfigRepository = dependency.userConfigRepository
    }
    
    public func start() {
        let vc = ClickToStartVC()
        let vm = ClickToStartVM()
        vm.coordinator = self
        vc.bind(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ClickToStartCO {
    
    func showCategoryScreen() {
        let coordinator = SelectMainCategoryCO(
            dependency: .init(
                viewModel: InitialSelectMainCategoryVM(userConfigRepository: userConfigRepository),
                navigationController: navigationController
            )
        )
        addChild(coordinator)
        coordinator.start()
    }
    
    func showShortFormHuntingScreen() {
        
    }
}
