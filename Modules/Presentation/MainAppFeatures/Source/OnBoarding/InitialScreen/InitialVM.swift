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
import Util

public class InitialVM: InitialViewModelable {
    
    public var viewDidLoad: RxRelay.PublishRelay<Void> = .init()
    
    public var tokenFlowNextable: RxCocoa.Driver<Void>
    public var alert: RxCocoa.Driver<Entity.CapAlertVO>?
    
    // Init
    let authUseCase: AuthUseCase
    
    public init(authUseCase: AuthUseCase) {
        self.authUseCase = authUseCase
        
        let checkExistingMemberResult = viewDidLoad
            .map { [authUseCase] _ in
                authUseCase.checkIsExistingMemeber()
            }
            .share()
        
        let userIsExistingMember = checkExistingMemberResult
            .filter { $0 }
        
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
        
        tokenFlowNextable = tokenGenerateSuccess
            .map { _ in
                printIfDebug("✅ 토큰 생성에 성공했습니다.")
            }
            .asDriver(onErrorJustReturn: ())
        
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
