//
//  MainScreenCO.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/17/24.
//

import UIKit
import Entity
import BaseFeature
import DSKit

public class MainScreenCO: Coordinator {
    
    public struct Dependency {
        var navigationController: UINavigationController?
        
        public init(navigationController: UINavigationController? = nil) {
            self.navigationController = navigationController
        }
    }
    
    public var viewController: UIViewController?
    public var navigationController: UINavigationController?
    
    public var children: [any BaseFeature.Coordinator] = []
    
    public var parent: (any BaseFeature.Coordinator)?
    
    public var finishDelegate: (any BaseFeature.CoordinatorFinishDelegate)?
    
    public init(dependency: Dependency) {
        self.navigationController = dependency.navigationController
    }
    
    public func start() {
        
        let pageInfo = CAPMainPage.allCases.map { page in
            let navigationController = createNavForTab(page: page)
            return CAPTabBarController.PageTabItemInfo(
                page: page,
                navigationController: navigationController
            )
        }
        
        let tabBarController = CAPTabBarController(
            initialPage: .home,
            info: pageInfo
        )
        
        navigationController?.pushViewController(tabBarController, animated: false)
    }
    
    // #1. Tab별 네비게이션 컨트롤러 생성
    func createNavForTab(page: CAPMainPage) -> UINavigationController {
        
        let tabNavController = UINavigationController()
        tabNavController.setNavigationBarHidden(true, animated: false)
        
        startTabCoordinator(
            page: page,
            navigationController: tabNavController
        )
        
        return tabNavController
    }
    
    // #2. 생성한 컨트롤러를 각 탭별 Coordinator에 전달
    func startTabCoordinator(page: CAPMainPage, navigationController: UINavigationController) {
        
        var childCoordinator: Coordinator!
        
        switch page {
        case .home:
            let coordinator = SummariesCO(dependency: .init(navigationController: navigationController))
            childCoordinator = coordinator
        case .inAppSummary:
            let coordinator = InAppSummatyCO(dependency: .init(navigationController: navigationController))
            childCoordinator = coordinator
        case .categoryAddition:
            let coordinator = CategoryAdditionCO(dependency: .init(navigationController: navigationController))
            childCoordinator = coordinator
        case .environmentalSetting:
            let coordinator = EnvSettingCO(dependency: .init(navigationController: navigationController))
            childCoordinator = coordinator
        }
        addChild(childCoordinator)
        // 코디네이터들을 실행
        childCoordinator.start()
    }
}
