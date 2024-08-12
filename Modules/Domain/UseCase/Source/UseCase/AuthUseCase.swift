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
public protocol AuthUseCase: UseCaseBase {
    
    /// 토큰 유무로 인증된 유저인지 확인합니다.
    func checkIsExistingMemeber() -> Bool
    
    /// 토큰을 생성합니다.
    func generateToken() -> Single<Result<Void, AuthError>>
    func generateToken() async throws -> Void
}

public class DefaultAuthUseCase: AuthUseCase {
    
    let authRepository: AuthRepository
    
    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    public func checkIsExistingMemeber() -> Bool {
        authRepository.checkAuthTokenExists()
    }
    
    public func generateToken() -> Single<Result<Void, Entity.AuthError>> {
        
        // 신규 유저 등록
        let imei = authRepository.createImei()
        
        // 생성된 imei값으로 토큰을 생성한다.
        return convert(task: authRepository.createAccessToken(imei: imei))
    }
    
    public func generateToken() async throws {
        
        // 신규 유저 등록
        let imei = authRepository.createImei()
        
        // 생성된 imei값으로 토큰을 생성한다.
        try await authRepository.createAccessToken(imei: imei)
    }
}
