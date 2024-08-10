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
        
        container.register(AuthService.self) { _ in
            return DefaultAuthService()
        }
        
        container.register(AuthRepository.self) { resolver in
            let service = resolver.resolve(AuthService.self)!
            return DefaultAuthRepository(authService: service)
        }
    }
}
