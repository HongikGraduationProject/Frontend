//
//  DefaultAuthRepository.swift
//  Repository
//
//  Created by choijunios on 8/9/24.
//

import Foundation

import UseCase
import DataSource
import Entity
import Util

import RxSwift

public class DefaultAuthRepository: AuthRepository {

    @Injected private var authService: AuthService
    
    public init() { }
    
    public func checkAuthTokenExists() -> Bool {
        if let accessToken: String = UserDefaultsDataSource.shared.fetchData(key: .accessToken) {
            printIfDebug("로컬에 저장된 토큰: \(accessToken)")
            return true
        }
        printIfDebug("저장된 토큰이 없습니다.")
        return false
    }
    
    public func createAccessToken(imei: String) -> RxSwift.Single<Void> {
        authService
            .request(api: .issueAccessToken(imei: imei), with: .plain)
            .map(CAPResponse<TokenDTO>.self)
            .map { [weak self] decoded in
                let accessToken = decoded.data!.accessToken
                self?.saveToken(accessToken: accessToken)
                return ()
            }
    }
    
    public func createAccessToken(imei: String) async throws {
        let body: CAPResponse<TokenDTO> = try await authService.requestDecodable(api: .issueAccessToken(imei: imei), with: .plain)
        let accessToken = body.data!.accessToken
        saveToken(accessToken: accessToken)
    }
    
    public func getImei() -> String? {
        UserDefaultsDataSource.shared.fetchData(key: .imei)
    }
    
    public func createImei() -> String {
        let uuidString = UUID().uuidString
        UserDefaultsDataSource.shared.saveData(key: .imei, value: uuidString)
        printIfDebug("✅ \(Self.self) imei값 저장 성공")
        return uuidString
    }
    
    private func saveToken(accessToken: String) {
        UserDefaultsDataSource.shared.saveData(key: .accessToken, value: accessToken)
        printIfDebug("✅ \(Self.self) 토큰을 저장 성공")
    }
}
