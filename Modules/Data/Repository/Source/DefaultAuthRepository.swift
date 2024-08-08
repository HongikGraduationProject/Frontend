//
//  DefaultAuthRepository.swift
//  Repository
//
//  Created by choijunios on 8/9/24.
//

import Foundation
import UseCase
import DataSource
import RxSwift
import Util

public class DefaultAuthRepository: AuthRepository {
    
    public func checkAuthTokenExists() -> Bool {
        if let accessToken: String = UserDefaultsDataSource.shared.fetchData(key: .accessToken) {
            printIfDebug("로컬에 저장된 토큰: \(accessToken)")
            return true
        }
        printIfDebug("저장된 토큰이 없습니다.")
        return false
    }
    
    public func createAccessToken() -> RxSwift.Single<Void> {
        .just(())
    }
    
    private func saveAccessToken() {
        
    }
    
    private func createImeiAndSave() {
        
        
    }
}
