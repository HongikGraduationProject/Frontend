//
//  AuthRepository.swift
//  UseCase
//
//  Created by choijunios on 8/9/24.
//

import Foundation
import RxSwift

public protocol AuthRepository {
    
    /// 로컬에 저장된 AuthToken정보를 확인합니다.
    func checkAuthTokenExists() -> Bool
    
    /// AccessToken을 생성합니다.
    func createAccessToken() -> Single<Void>
}
