//
//  EnvSettingCO.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/18/24.
//

import UIKit
import Entity
import PresentationUtil

public class EnvSettingCO: Coordinator {
    
    public struct Dependency {
        var navigationController: UINavigationController?
        public init(navigationController: UINavigationController? = nil) {
            self.navigationController = navigationController
        }
    }
    
    public var viewController: UIViewController?
    public var navigationController: UINavigationController?
    
    public var children: [Coordinator] = []
    public var parent: (Coordinator)?
    
    public var finishDelegate: (CoordinatorFinishDelegate)?
    
    public init(dependency: Dependency) {
        self.navigationController = dependency.navigationController
    }
    
    public func start() {
        let vc = EnvSettingVC()
        navigationController?.pushViewController(vc, animated: false)
    }

}

