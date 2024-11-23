//
//  DataAssembly.swift
//  App
//
//  Created by choijunios on 8/11/24.
//

import Swinject
import UseCase
import Repository
import DataSource

public struct DataAssembly: Assembly {
    public func assemble(container: Container) {
        
        // MARK: Services
        container.register(AuthService.self) { _ in
            return DefaultAuthService()
        }
        
        container.register(SummaryService.self) { _ in
            return DefaultSummaryService()
        }
        
        container.register(CoreDataService.self) { _ in
            return DefaultCoreDataService()
        }.inObjectScope(.container)
        
        container.register(RequestCountTracker.self) { _ in
            
            DefaultRequestCountTracker()
        }
        
        
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
        
        // ⭐️ 해당 레포지토리는 같은 인스턴스를 공유합니다.
        container.register(SummaryDetailRepository.self) { _ in
            DefaultSummaryDetailRepository()
        }.inObjectScope(.container)
    }
}
