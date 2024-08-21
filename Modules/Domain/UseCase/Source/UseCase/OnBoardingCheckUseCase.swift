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
        let videoCodeRepository: VideoCodeRepository
        
        public init(userConfigRepository: UserConfigRepository, summaryRequestRepository: SummaryRequestRepository, videoCodeRepository: VideoCodeRepository) {
            self.userConfigRepository = userConfigRepository
            self.summaryRequestRepository = summaryRequestRepository
            self.videoCodeRepository = videoCodeRepository
        }
    }
    
    let userConfigRepository: UserConfigRepository
    let summaryRequestRepository: SummaryRequestRepository
    let videoCodeRepository: VideoCodeRepository
    
    public init(dependency: Dependency) {
        self.userConfigRepository = dependency.userConfigRepository
        self.summaryRequestRepository = dependency.summaryRequestRepository
        self.videoCodeRepository = dependency.videoCodeRepository
    }
    
    public func checkingSelectedCategoriesExists() -> Bool {
        let categories = userConfigRepository.getPreferedCategories()
        return categories != nil
    }
    
    public func checkingSummariesExists() -> RxSwift.Single<Result<Bool, Entity.SummariesError>> {
        
        let task = summaryRequestRepository
            .fetchAllSummaryItems()
            .map { [videoCodeRepository] items in
                // 비디오 코드수 + 요약된 리스트
                let videoCodes = videoCodeRepository.getVideoCodes()
                return (items.count + videoCodes.count) > 0
            }
        return convert(task: task)
    }
}
