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
    func executeCheckSavedShortFormFlow()
    
    // Screen
    func showCategorySelectionScreen()
    func showShortFormHuntingScreen()
}
