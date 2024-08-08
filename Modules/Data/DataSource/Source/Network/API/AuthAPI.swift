//
//  AuthAPI.swift
//  DataSource
//
//  Created by choijunios on 8/9/24.
//

import Foundation
import Moya
import Alamofire

/// AuthAPI
public enum AuthAPI {
    
    case issueAccessToken(imei: String)
}

extension AuthAPI: BaseAPI {

    public var apiType: APIType { .auth}
    
    public var method: Moya.Method {
        
        switch self {
        case .issueAccessToken:
            .post
        }
    }
    
    public var path: String {
        switch self {
        case .issueAccessToken(let imei):
            ""
        }
    }
    
    var bodyParameters: Parameters? {
        var params: Parameters = [:]
        switch self {
        case .issueAccessToken(let imei):
            params["imei"] = imei
        }
        return params
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        default:
            return JSONEncoding.default
        }
    }
    
    public var task: Task {
        switch self {
        case .issueAccessToken:
            return .requestParameters(parameters: bodyParameters ?? [:], encoding: parameterEncoding)
        }
    }
}
