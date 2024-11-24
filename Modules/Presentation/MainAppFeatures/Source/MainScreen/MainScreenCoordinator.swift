//
//  MainScreenCoordinator.swift
//  Shortcap
//
//  Created by choijunios on 11/23/24.
//

import UIKit

import PresentationUtil
import CommonUI


public class MainScreenCoordinator: Coordinator {
    
    public let navigationController: UINavigationController
    
    
    public var children: [Coordinator] = []
    public weak var parent: (Coordinator)?
    public weak var finishDelegate: (CoordinatorFinishDelegate)?
    
    
    public init(navigationController: UINavigationController) {
        
        self.navigationController = navigationController
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
        
        navigationController.pushViewController(tabBarController, animated: true)
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
            
            
            let coordinator = SummaryListPageCoordinator(
                navigationController: navigationController
            )
            childCoordinator = coordinator
            
            
        case .inAppSummary:
            
            
            let coordinator = InAppSummaryPageCoordinator(
                navigationController: navigationController
            )
            childCoordinator = coordinator
            
            
        case .categoryAddition:
            
            
            let coordinator = CategoryAdditionPageCoordinator(
                navigationController: navigationController
            )
            childCoordinator = coordinator
            
            
        case .environmentalSetting:
            
            
            let coordinator = EnvironmentSettingPageCoordinator(
                navigationController: navigationController
            )
            childCoordinator = coordinator
            
            
        }
        
        
        addChild(childCoordinator)
        // 코디네이터들을 실행
        childCoordinator.start()
    }
}
