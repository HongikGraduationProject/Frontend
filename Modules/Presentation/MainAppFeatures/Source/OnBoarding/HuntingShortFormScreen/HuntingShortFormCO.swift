//
//  HuntingShortFormCO.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/13/24.
//

import UIKit
import BaseFeature

public class HuntingShortFormCO: Coordinator {
    
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
        let vc = HuntingShortFormVC()
        let vm = HuntingShortFormVM()
        vc.bind(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}
