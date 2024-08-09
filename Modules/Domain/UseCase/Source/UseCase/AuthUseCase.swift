//
//  AuthUseCase.swift
//  UseCase
//
//  Created by choijunios on 8/9/24.
//

import Foundation
import Entity
import RxSwift

/// 유저의 인증/인가 유스케이스
public protocol AuthUseCase {
    
    /// 유효한 토큰 값을 가져옵니다.
    func executeTokenFlow() -> Single<Result<Void, AuthError>>
}

public class DefaultAuthUseCase: AuthUseCase {
    
    let authRepository: AuthRepository
    
    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    public func executeTokenFlow() -> Single<Result<Void, Entity.AuthError>> {
        
        // 토큰이 로컬에 존재하는 지 확인한다.
        if !authRepository.checkAuthTokenExists() {
            
            // 신규 유저 등록
            let imei = authRepository.createImei()
            
            // 생성된 imei값으로 토큰을 생성한다.
            return authRepository
                .createAccessToken(imei: imei)
                .map { _ in .success(()) }
        }
        
        return .just(.success(()))
    }
}
