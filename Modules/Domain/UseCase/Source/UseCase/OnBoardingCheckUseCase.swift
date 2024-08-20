//
//  OnBoardingCheckUseCase.swift
//  UseCase
//
//  Created by choijunios on 8/13/24.
//

import Foundation
import Entity
import RxSwift

public protocol OnBoardingCheckUseCase: UseCaseBase {
    
    /// 로컬에 저장된 카테고리가 있는지 확인합니다.
    func checkingSelectedCategoriesExists() -> Bool
    
    /// 로컬에 저장된 비디오가 있는지 확인합니다.
    func checkingSummariesExists() -> Single<Result<Bool, SummariesError>>
}

public class DefaultOnBoardingCheckUseCase: OnBoardingCheckUseCase {
    
    public struct Dependency {
        let userConfigRepository: UserConfigRepository
        let summaryRequestRepository: SummaryRequestRepository
        
        public init(userConfigRepository: UserConfigRepository, summaryRequestRepository: SummaryRequestRepository) {
            self.userConfigRepository = userConfigRepository
            self.summaryRequestRepository = summaryRequestRepository
        }
    }
    
    let userConfigRepository: UserConfigRepository
    let summaryRequestRepository: SummaryRequestRepository
    
    public init(dependency: Dependency) {
        self.userConfigRepository = dependency.userConfigRepository
        self.summaryRequestRepository = dependency.summaryRequestRepository
    }
    
    public func checkingSelectedCategoriesExists() -> Bool {
        let categories = userConfigRepository.getPreferedCategories()
        return categories != nil
    }
    
    public func checkingSummariesExists() -> RxSwift.Single<Result<Bool, Entity.SummariesError>> {
        convert(task: summaryRequestRepository
            .fetchAllSummaryItems()
            .map { summaryItmes in
                return !summaryItmes.isEmpty
            })
    }
}
