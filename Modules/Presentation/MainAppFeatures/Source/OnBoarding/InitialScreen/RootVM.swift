//
//  InitialVM.swift
//  MainAppFeatures
//
//  Created by choijunios on 8/11/24.
//

import Foundation
import Entity
import RxSwift
import RxCocoa
import UseCase
import BaseFeature
import Util

public protocol RootViewModelable: BaseVMable {
    
    var coordinator: RootCoordinator? { get set }
    
    // Input
    var viewDidLoad: PublishRelay<Void> { get }
    
    // Output
    
}

public class RootVM: RootViewModelable {
    
    let userConfigRepository: UserConfigRepository
    
    public weak var coordinator: RootCoordinator?
    
    // Input
    public var viewDidLoad: RxRelay.PublishRelay<Void> = .init()
    
    // Output
    public var alert: RxCocoa.Driver<Entity.CapAlertVO>?
    
    // Init
    let authUseCase: AuthUseCase
    
    let disposeBag: DisposeBag = .init()
    
    public init(
        coordinator: RootCoordinator,
        authUseCase: AuthUseCase,
        userConfigRepository: UserConfigRepository
    ) {
        self.coordinator = coordinator
        self.authUseCase = authUseCase
        self.userConfigRepository = userConfigRepository
        
        // MARK: 토큰 확인 플로우
        let checkExistingMemberResult = viewDidLoad
            .map { [authUseCase] _ in
                authUseCase.checkIsExistingMemeber()
            }
            .share()
        
        let userIsExistingMember = checkExistingMemberResult
            .filter { $0 }
            .map { _ in () }
        
        let userIsfreshMan = checkExistingMemberResult
            .filter { !$0 }
        
        let tokenGenerationResult = userIsfreshMan
            .flatMap { _ in
                authUseCase
                    .generateToken()
            }
            .share()
        
        let tokenGenerateSuccess = tokenGenerationResult.compactMap { $0.value }
        let tokenGenerateFailure = tokenGenerationResult.compactMap { $0.error }
        
        let tokenFlowFinishSuccessFully = tokenGenerateSuccess
            .map { _ in
                printIfDebug("✅ 토큰 생성에 성공했습니다.")
                return ()
            }
        
        // MARK: 카테고리 확인 플로우
        // 1. 기존유저이나 카테고리를 선택하지 않은 경우
        // 2. 새로운 유저인 경우
        
        let checkCategoriesExistsResult = Observable
            .merge(
                userIsExistingMember,
                tokenFlowFinishSuccessFully
            )
            .map { [userConfigRepository] _ in
                userConfigRepository.getPreferedCategories()
            }
        
        let categoryExists = checkCategoriesExistsResult.filter { $0 != nil }
        let categoryDoentExist = checkCategoriesExistsResult.filter { $0 == nil }
        
        // 카테고리 선택화면으로 이동
        categoryDoentExist
            .subscribe { [weak coordinator] _ in
                // 카테고리를 선택하는 화면으로 이동
                coordinator?.clickToStartScreen()
            }
            .disposed(by: disposeBag)
        
        // MARK: 저장된 숏폼이 있는지 확인
        
        
        // 토큰 생성 실패
        alert = tokenGenerateFailure
            .map { authError in
                return CapAlertVO(
                    title: "시스템 오류",
                    message: authError.message,
                    info: [
                        "닫기": {
                            // 어플리케이션을 강제 종료합니다.
                            exit(0)
                        }
                    ]
                )
            }
            .asDriver(onErrorJustReturn: .default)
    }
    
}
