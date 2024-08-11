//
//  PresentationAssembly.swift
//  App
//
//  Created by choijunios on 8/12/24.
//

import MainAppFeatures
import Swinject
import UseCase

public struct PresentationAssembly: Assembly {
    public func assemble(container: Container) {
        container.register(SelectMainCategoryViewModelable.self, name: "Init") { resolver in
            let repository = resolver.resolve(UserConfigRepository.self)!
            return InitialSelectMainCategoryVM(
                userConfigRepository: repository
            )
        }
    }
}
