//
//  DomainAssembly.swift
//  App
//
//  Created by choijunios on 8/11/24.
//

import UseCase
import RepositoryInterface
import Swinject

public struct DomainAssembly: Assembly {
    public func assemble(container: Container) {
        
        
        container.register(RequestCountTracker.self) { _ in
            DefaultRequestCountTracker()
        }
        
        
        container.register(AuthUseCase.self) { _ in
            DefaultAuthUseCase()
        }
        
        
        container.register(OnBoardingCheckUseCase.self) { _ in
            DefaultOnBoardingCheckUseCase()
        }
        
        
        container.register(SummaryUseCase.self) { _ in
            DefaultSummaryUseCase()
        }
        .inObjectScope(.transient)
        
        
        container.register(SummarySearchUseCase.self) { _ in
            
            DefaultSummarySearchUseCase()
        }
    }
}
