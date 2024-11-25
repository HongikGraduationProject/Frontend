//
//  AuthError.swift
//  Entity
//
//  Created by choijunios on 8/9/24.
//

import Foundation

public enum AuthError: String, DomainError {
    
    case networkNotConnected="CAP-001"
    case undefinedError="CAP-000"
    
    public var message: String {
        switch self {
        case .networkNotConnected:
            "네트워크 연결을 확인해 주세요."
        case .undefinedError:
            "알 수 없는 에러가 발생했습니다."
        }
    }
}
