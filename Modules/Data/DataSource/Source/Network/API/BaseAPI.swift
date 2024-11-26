//
//  BaseAPI.swift
//  DataSource
//
//  Created by choijunios on 8/9/24.
//

import Foundation

import Util

import Moya

/// Shortcap API 도메인 타입입니다.
public enum APIType {
    
    case auth
    case summaries
}

/// API의 베이스가되는 타입입니다.
/// 해당 프로토콜을 채택하여 특정 도메인의 API서비스를 구현할 수 있습니다.
public protocol BaseAPI: TargetType {
    
    var apiType: APIType { get }
}

public extension BaseAPI {
    
    var baseURL: URL {
        
        let configControler = DependencyInjector.shared.resolve(NetworkConfigController.self)
        
        var baseUrlString = configControler.requestBaseURL()!
        
        switch apiType {
        case .auth:
            baseUrlString += "/auth"
        case .summaries:
            baseUrlString += "/summaries"
        }
        
        return URL(string: baseUrlString)!
    }
    
    var headers: [String : String]? {
        
        switch apiType {
        default:
            ["Content-Type": "application/json"]
        }
    }
    
    var validationType: ValidationType { .successCodes }
}
