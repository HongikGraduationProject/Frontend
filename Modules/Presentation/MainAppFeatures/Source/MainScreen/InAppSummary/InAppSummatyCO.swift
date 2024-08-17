//
//  InAppSummatyCO.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/18/24.
//

import UIKit
import Entity
import BaseFeature

public class InAppSummatyCO: Coordinator {
    
    public struct Dependency {
        var navigationController: UINavigationController?
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
        let vc = InAppSummatyVC()
        navigationController?.pushViewController(vc, animated: false)
    }

}

