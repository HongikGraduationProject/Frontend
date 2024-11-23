//
//  RootCoordinator.swift
//  BaseFeature
//
//  Created by choijunios on 8/11/24.
//

import Foundation

public protocol RootCoordinator: Coordinator {
    
    func presentMainTabBar()
    
    func presentClickToStartPage()
    
    func presentChoosePlatformPage()
}
