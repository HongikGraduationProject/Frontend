//
//  SelectMainCategoryCO.swift
//  BaseFeature
//
//  Created by choijunios on 8/12/24.
//

import UIKit
import UseCase
import PresentationUtil

public class SelectMainCategoryCO: Coordinator {
    
    public struct Dependency {
        var viewModel: SelectMainCategoryViewModelable?
        let videoCodeRepository: VideoCodeRepository
        var navigationController: UINavigationController?
        
        public init(viewModel: SelectMainCategoryViewModelable? = nil, videoCodeRepository: VideoCodeRepository, navigationController: UINavigationController? = nil) {
            self.viewModel = viewModel
            self.videoCodeRepository = videoCodeRepository
            self.navigationController = navigationController
        }
    }
    
    public var viewController: UIViewController?
    public var navigationController: UINavigationController?
    
    public var children: [Coordinator] = []
    public var parent: (Coordinator)?
    
    public var finishDelegate: (CoordinatorFinishDelegate)?
    
    let viewModel: SelectMainCategoryViewModelable!
    let videoCodeRepository: VideoCodeRepository
    
    public init(dependency: Dependency) {
        self.navigationController = dependency.navigationController
        self.videoCodeRepository = dependency.videoCodeRepository
        self.viewModel = dependency.viewModel
    }
    
    public func start() {
        self.viewModel.coordinator = self
        let vc = SelectMainCategoryVC(viewModel: viewModel)
        vc.bind()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: InitFlow
extension SelectMainCategoryCO {
    
    func finishOnBoardingFlow() {
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        finish(true)
    }
    
    func showShortFormHuntingScreen() {
        let coordinator = HuntingShortFormCO(
            dependency: .init(
                navigationController: navigationController,
                videoCodeRepository: videoCodeRepository
            )
        )
        addChild(coordinator)
        coordinator.start()
    }
}
