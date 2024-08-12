//
//  RootCoordinator.swift
//  BaseFeature
//
//  Created by choijunios on 8/11/24.
//

import Foundation

public protocol RootCoordinator: Coordinator {
    // Flow
    func executeMainTabBarFlow()
    
    // Screen
    /// 신규 유저가 확인하는 화면입니다.
    func clickToStartScreen()
    
    /// 숏폼이 없는 경우 이동하는 화면입니다.
    func showShortFormHuntingScreen()
}
