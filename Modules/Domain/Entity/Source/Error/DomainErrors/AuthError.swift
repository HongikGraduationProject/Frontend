//
//  AuthError.swift
//  Entity
//
//  Created by choijunios on 8/9/24.
//

import Foundation

public enum AuthError: Error {
    
    case unknowmError
    
    public var message: String {
        switch self {
        case .unknowmError:
            "알 수 없는 에러가 발생했습니다."
        }
    }
}
