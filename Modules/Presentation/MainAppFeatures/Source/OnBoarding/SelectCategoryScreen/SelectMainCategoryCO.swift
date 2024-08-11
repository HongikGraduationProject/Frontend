//
//  SelectMainCategoryCO.swift
//  BaseFeature
//
//  Created by choijunios on 8/12/24.
//

import UIKit
import BaseFeature

public class SelectMainCategoryCO: Coordinator {
    
    public struct Dependency {
        weak var viewModel: SelectMainCategoryViewModelable?
        var navigationController: UINavigationController
    }
    
    public var viewController: UIViewController?
    public var navigationController: UINavigationController?
    
    public var children: [any BaseFeature.Coordinator] = []
    public var parent: (any BaseFeature.Coordinator)?
    
    public var finishDelegate: (any BaseFeature.CoordinatorFinishDelegate)?
    
    weak var viewModel: SelectMainCategoryViewModelable!
    
    init(dependency: Dependency) {
        self.navigationController = dependency.navigationController
        self.viewModel = dependency.viewModel
    }
    
    public func start() {
        
        let vc = SelectMainCategoryVC(viewModel: viewModel)
        vc.bind()
        navigationController?.pushViewController(vc, animated: true)
    }
}
