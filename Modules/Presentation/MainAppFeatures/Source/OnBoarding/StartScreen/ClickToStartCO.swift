//
//  ClickToStartCO.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/12/24.
//

import UIKit
import PresentationUtil
import UseCase

public class ClickToStartCO: Coordinator {
    
    public struct Dependency {
        let userConfigRepository: UserConfigRepository
        let videoCodeRepository: VideoCodeRepository
        let onBoardingCheckUseCase: OnBoardingCheckUseCase
        let navigationController: UINavigationController?
        
        public init(
            userConfigRepository: UserConfigRepository,
            videoCodeRepository: VideoCodeRepository,
            onBoardingCheckUseCase: OnBoardingCheckUseCase,
            navigationController: UINavigationController?
        ) {
            self.userConfigRepository = userConfigRepository
            self.videoCodeRepository = videoCodeRepository
            self.onBoardingCheckUseCase = onBoardingCheckUseCase
            self.navigationController = navigationController
        }
    }
    
    public var viewController: UIViewController?
    public var navigationController: UINavigationController?
    
    public var children: [Coordinator] = []
    public var parent: (Coordinator)?
    public var finishDelegate: (CoordinatorFinishDelegate)?
    
    let userConfigRepository: UserConfigRepository
    let videoCodeRepository: VideoCodeRepository
    let onBoardingCheckUseCase: OnBoardingCheckUseCase
    
    public init(dependency: Dependency) {
        self.navigationController = dependency.navigationController
        self.userConfigRepository = dependency.userConfigRepository
        self.videoCodeRepository = dependency.videoCodeRepository
        self.onBoardingCheckUseCase = dependency.onBoardingCheckUseCase
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
                viewModel: InitialSelectMainCategoryVM(
                    onBoardingUseCase: onBoardingCheckUseCase,
                    userConfigRepository: userConfigRepository
                ),
                videoCodeRepository: videoCodeRepository,
                navigationController: navigationController
            )
        )
        addChild(coordinator)
        coordinator.start()
    }
}
