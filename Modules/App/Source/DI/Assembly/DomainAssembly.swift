//
//  DomainAssembly.swift
//  App
//
//  Created by choijunios on 8/11/24.
//

import UseCase
import Swinject

public struct DomainAssembly: Assembly {
    public func assemble(container: Container) {
        container.register(AuthUseCase.self) { resolver in
            let repository = resolver.resolve(AuthRepository.self)!
            return DefaultAuthUseCase(authRepository: repository)
        }
    }
}
