//
//  DataAssembly.swift
//  App
//
//  Created by choijunios on 8/11/24.
//

import RepositoryInterface
import Repository
import DataSource

import Swinject

public struct DataAssembly: Assembly {
    public func assemble(container: Container) {
        
        // MARK: Network config
        container.register(NetworkConfigController.self) { _ in
            DefaultNetworkConfigController()
        }
        
        
        // MARK: Services
        container.register(AuthService.self) { _ in
            DefaultAuthService()
        }
        
        
        container.register(SummaryService.self) { _ in
            DefaultSummaryService()
        }
        
        
        container.register(CoreDataService.self) { _ in
            DefaultCoreDataService()
        }.inObjectScope(.container)
        
        
        // MARK: Repositories
        container.register(UserConfigRepository.self) { resolver in
            DefaultUserConfigRepository()
        }
        
        
        container.register(AuthRepository.self) { _ in
            DefaultAuthRepository()
        }
        
        
        container.register(VideoCodeRepository.self) { _ in
            DefaultVideoCodeRepository()
        }
        
        
        container.register(SummaryRequestRepository.self) { _ in
            DefaultSummaryRequestRepository()
        }
        
        
        container.register(SummarizedItemRepository.self) { _ in
            DefaultSummarizedItemRepository()
        }
        
        
        container.register(SummarySearchRepository.self) { _ in
            DefualtSummarySearchRepository()
        }
        
        
        // ⭐️ 해당 레포지토리는 같은 인스턴스를 공유합니다.
        container.register(SummaryDetailRepository.self) { _ in
            DefaultSummaryDetailRepository()
        }.inObjectScope(.container)
    }
}
