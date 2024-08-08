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
    
    /// AccessToken을 생성한 후 로컬저장소에 저장합니다.
    func createAccessToken(imei: String) -> Single<Void>
    
    /// Imei값을 가져옵니다.
    func getImei() -> String?
    
    /// Imei값을 생성하고 로컬에 저장합니다.
    func createImei() -> String
}
