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
    
    let userConfigRepository: UserConfigRepository
    let summariesRepository: SummariesRepository
    
    public init(userConfigRepository: UserConfigRepository, summariesRepository: SummariesRepository) {
        self.userConfigRepository = userConfigRepository
        self.summariesRepository = summariesRepository
    }
    
    public func checkingSelectedCategoriesExists() -> Bool {
        let categories = userConfigRepository.getPreferedCategories()
        return categories != nil
    }
    
    public func checkingSummariesExists() -> RxSwift.Single<Result<Bool, Entity.SummariesError>> {
        convert(task: summariesRepository
            .getAllVideoList()
            .map { summaries in
                return !summaries.isEmpty
            })
    }
}
