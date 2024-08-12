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
        
        container.register(UserConfigRepository.self) { resolver in
            return DefaultUserConfigRepository()
        }
        
        container.register(AuthService.self) { _ in
            return DefaultAuthService()
        }
        
        container.register(AuthRepository.self) { resolver in
            let service = resolver.resolve(AuthService.self)!
            return DefaultAuthRepository(authService: service)
        }
        
        container.register(SummariesService.self) { _ in
            return DefaultSummariesService()
        }
        
        // 해당 레포지토리는 같은 인스턴스를 공유합니다.
        container.register(SummariesRepository.self) { resolver in
            let service = resolver.resolve(SummariesService.self)!
            return DefaultSummariesRepository(
                service: service
            )
        }.inObjectScope(.transient)
    }
}
