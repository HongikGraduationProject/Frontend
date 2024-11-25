//
//  Assembly.swift
//  Shortcap
//
//  Created by choijunios on 11/24/24.
//

import UseCase
import RepositoryInterface
import Repository
import DataSource

import Swinject

public struct AppExtensionAssembly: Assembly {
    public func assemble(container: Container) {
        
        // MARK: Services
        container.register(SummaryService.self) { _ in
            return DefaultSummaryService()
        }
        
        
        container.register(CoreDataService.self) { _ in
            return DefaultCoreDataService()
        }
        
        
        container.register(AuthService.self) { _ in
            return DefaultAuthService()
        }
        
        
        
        // MARK: Repository
        container.register(VideoCodeRepository.self) { _ in
            DefaultVideoCodeRepository()
        }
        
        
        container.register(SummaryRequestRepository.self) { _ in
            DefaultSummaryRequestRepository()
        }
        
        
        container.register(AuthRepository.self) { _ in
            DefaultAuthRepository()
        }
        
        
        
        // MARK: UseCase
        container.register(AuthUseCase.self) { _ in
            DefaultAuthUseCase()
        }
    }
}
