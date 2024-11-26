//
//  SummariesError.swift
//  Entity
//
//  Created by choijunios on 8/13/24.
//

import Foundation

public enum SummariesError: String, DomainError {
    
    case networkNotConnected="CAP-001"
    case summaryRequestFailed="CAP-002"
    case undefinedError="CAP-000"
    
    public var message: String {
        switch self {
        case .summaryRequestFailed:
            "요약 요청에 실패했어요"
        case .networkNotConnected:
            "네트워크 연결을 확인해 주세요."
        case .undefinedError:
            "알 수 없는 에러가 발생했습니다."
        }
    }
}
