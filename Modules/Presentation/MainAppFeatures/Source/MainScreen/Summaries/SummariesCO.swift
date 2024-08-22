//
//  SummariesCO.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/18/24.
//

import UIKit
import Entity
import BaseFeature
import UseCase

public class SummariesCO: Coordinator {
    
    public struct Dependency {
        let summaryUseCase: SummaryUseCase
        let summaryDetailRepository: SummaryDetailRepository
        var navigationController: UINavigationController?
        
        public init(summaryUseCase: SummaryUseCase, summaryDetailRepository: SummaryDetailRepository, navigationController: UINavigationController? = nil) {
            self.summaryUseCase = summaryUseCase
            self.summaryDetailRepository = summaryDetailRepository
            self.navigationController = navigationController
        }
    }
    
    public var viewController: UIViewController?
    public var navigationController: UINavigationController?
    
    public var children: [any BaseFeature.Coordinator] = []
    public var parent: (any BaseFeature.Coordinator)?
    
    public var finishDelegate: (any BaseFeature.CoordinatorFinishDelegate)?
    
    let summaryUseCase: SummaryUseCase
    let summaryDetailRepository: SummaryDetailRepository
    
    public init(dependency: Dependency) {
        self.summaryUseCase = dependency.summaryUseCase
        self.summaryDetailRepository = dependency.summaryDetailRepository
        self.navigationController = dependency.navigationController
    }
    
    public func start() {
        
        let vc = SummariesVC()
        let vm = SummariesVM(
            dependency: .init(
                coordinator: self,
                summaryUseCase: summaryUseCase,
                summaryDetailRepository: summaryDetailRepository
            )
        )
        vc.bind(viewModel: vm)
        viewController = vc
        navigationController?.pushViewController(vc, animated: false)
    }
    
    public func showDetail(videoId: Int) {
        // 추후 Coordinator생성
        let vc = SummaryDetailVC()
        let vm = SummaryDetailVM(videoId: videoId, repo: summaryDetailRepository)
        
        vc.bind(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}
