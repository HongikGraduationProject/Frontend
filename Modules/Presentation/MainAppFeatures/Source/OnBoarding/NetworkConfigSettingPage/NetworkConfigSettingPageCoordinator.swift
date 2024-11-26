//
//  NetworkConfigSettingPageCoordinator.swift
//  Shortcap
//
//  Created by choijunios on 11/26/24.
//

import UIKit
import SwiftUI

import PresentationUtil

public class NetworkConfigSettingPageCoordinator: Coordinator {
    
    public let navigationController: UINavigationController
    
    
    public var children: [Coordinator] = []
    public weak var parent: (Coordinator)?
    public weak var finishDelegate: (CoordinatorFinishDelegate)?
    
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        
        let view = NetworkConfigSettingView { [weak self] in
            
            self?.finish(true)
        }
        let hostingView = UIHostingController(rootView: view)
        
        navigationController.pushViewController(hostingView, animated: true)
    }
}
