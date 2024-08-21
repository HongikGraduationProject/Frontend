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
        
        container.register(OnBoardingCheckUseCase.self) { resolver in
            let userConfigRepository = resolver.resolve(UserConfigRepository.self)!
            let summaryRequestRepository = resolver.resolve(SummaryRequestRepository.self)!
            return DefaultOnBoardingCheckUseCase(
                dependency: .init(
                    userConfigRepository: userConfigRepository,
                    summaryRequestRepository: summaryRequestRepository
                )
            )
        }
        
        container.register(SummaryUseCase.self) { resolver in
            let videoCodeRepository = resolver.resolve(VideoCodeRepository.self)!
            let summaryRequestRepository = resolver.resolve(SummaryRequestRepository.self)!
            let summaryDetailRepository = resolver.resolve(SummaryDetailRepository.self)!
            return DefaultSummaryUseCase(
                dependency: .init(
                    summaryRequestRepository: summaryRequestRepository,
                    summaryDetailRepository: summaryDetailRepository,
                    videoCodeRepository: videoCodeRepository
                )
            )
        }
        .inObjectScope(.transient)
    }
}
