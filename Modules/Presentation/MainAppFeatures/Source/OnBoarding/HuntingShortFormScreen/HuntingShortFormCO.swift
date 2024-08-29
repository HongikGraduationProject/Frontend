//
//  HuntingShortFormCO.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/13/24.
//

import UIKit
import UseCase
import PresentationUtil

public class HuntingShortFormCO: Coordinator {
    
    public struct Dependency {
        var navigationController: UINavigationController?
        let videoCodeRepository: VideoCodeRepository
        
        public init(navigationController: UINavigationController? = nil, videoCodeRepository: VideoCodeRepository) {
            self.navigationController = navigationController
            self.videoCodeRepository = videoCodeRepository
        }
    }
    
    public var viewController: UIViewController?
    public var navigationController: UINavigationController?
    public var children: [Coordinator] = []
    public var parent: (Coordinator)?
    
    let videoCodeRepository: VideoCodeRepository
    
    public var finishDelegate: (CoordinatorFinishDelegate)?
    
    public init(dependency: Dependency) {
        self.navigationController = dependency.navigationController
        self.videoCodeRepository = dependency.videoCodeRepository
    }
    
    public func start() {
        let vc = HuntingShortFormVC()
        let vm = HuntingShortFormVM(
            coordinator: self,
            videoCodeRepository: videoCodeRepository
        )
        vc.bind(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    public func showMainTapBarFlow() {
        if let rootCoordinator = parent as? RootCoordinator {
            rootCoordinator.executeMainTabBarFlow()
        }
        else if let rootCoordinator = parent as? ClickToStartCO {
            (rootCoordinator.parent as? RootCoordinator)?.executeMainTabBarFlow()
        }
        else if let rootCoordinator = parent as? SelectMainCategoryCO {
            (rootCoordinator.parent?.parent as? RootCoordinator)?.executeMainTabBarFlow()
        }
    }
}
